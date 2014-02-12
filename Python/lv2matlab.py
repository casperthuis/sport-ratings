import requests
import numpy
import scipy.io
import argparse
from slugify import slugify

parser = argparse.ArgumentParser()
parser.add_argument("tournament_id", help="generate matrix from tournament with this leaguevine id",
                    type=int)
args = parser.parse_args()
tournament_id = args.tournament_id

HOST = "https://api.leaguevine.com"

TOURNAMENT_ID = u'19178'
TOKEN = u'abcdefgh'
URL = u'{0}/v1/tournaments/{1}/?access_token={2}'.format(HOST, tournament_id, TOKEN)
response = requests.get(URL)
if response.status_code == 400:
    raise Exception('no tournament with id {0} found'.format(tournament_id))
tournament = response.json()


URL = u'{0}/v1/games/?tournament_id={1}&fields=%5Bid%2C%20swiss_round%2C%20team_1_id%2Cteam_2_id%2Cteam_1%2Cteam_2%2Cteam_1_score%2Cteam_2_score%5D&order_by=%5Bstart_time%5D&limit=200&access_token={2}'.format(HOST, tournament_id, TOKEN)
response = requests.get(URL)
if response.status_code == 400 or response.json()['meta']['total_count'] == 0:
    raise Exception('no games found')

games = response.json()['objects']

# 1. create lists of all team_ids involved in "games" and all game_ids
team_id_list = []
team_name_list = []
game_id_list = []
for game in games:
    game_id_list.append(game['id'])
    if game['team_1_id'] not in team_id_list:
        team_id_list.append(game['team_1_id'])
        if game['team_1']['short_name']:
            team_name_list.append(game['team_1']['short_name'])
        else:
            team_name_list.append(game['team_1']['name'])
    if game['team_2_id'] not in team_id_list:
        team_id_list.append(game['team_2_id'])
        if game['team_2']['short_name']:
            team_name_list.append(game['team_2']['short_name'])
        else:
            team_name_list.append(game['team_2']['name'])

num_teams = len(team_id_list)
num_games = len(game_id_list)

# 2. set up matrices W and scores
W = numpy.zeros( (num_games, num_teams), int)
scores = numpy.zeros( (num_games, 2), int)
i_game = 0
for game in games:
    if game['team_1_score'] >= game['team_2_score']: # team 1 won or the teams tied
        W[i_game, team_id_list.index(game['team_1_id'])] = 1
        W[i_game, team_id_list.index(game['team_2_id'])] = -1
        scores[i_game, 0] = game['team_1_score']
        scores[i_game, 1] = game['team_2_score']
    else:
        W[i_game, team_id_list.index(game['team_1_id'])] = -1
        W[i_game, team_id_list.index(game['team_2_id'])] = 1
        scores[i_game, 0] = game['team_2_score']
        scores[i_game, 1] = game['team_1_score']
    i_game += 1

print 'processed {0} games'.format(i_game)

# 3. Make numpy object array for team names
#team_name_arr = numpy.zeros((num_teams,), dtype=numpy.object)
team_name_arr = numpy.array(team_name_list, dtype=numpy.object)

# 4. Save tournament name
tournament_name = numpy.array(tournament['name'], dtype=numpy.object)
file_name = '{0}_{1}'.format(tournament_id, slugify(tournament['name']))

scipy.io.savemat('{0}.mat'.format(file_name), mdict={'W': W,
                                     's': scores,
                                     'team_names': team_name_arr,
                                     'tournament_name': tournament_name})

print "wrote matrices to {0}.mat".format(file_name)
