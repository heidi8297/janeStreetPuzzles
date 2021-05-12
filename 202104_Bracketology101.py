# this script was written to solve the April 2021 Jane Street puzzle "Bracketology"
# unfortunately I screwed up on something trivial and failed to submit the correct solution!
# I reported the indices of the seeds (2 and 11) to swap instead of the seed numbers themselves (16 and 3)


import math
import copy
import random

# the initial team/seed bracket
bracketInit = {
    "1x":{1:1},
    "1y":{16:1},
    "2x":{8:1},
    "2y":{9:1},
    "3x":{5:1},
    "3y":{12:1},
    "4x":{4:1},
    "4y":{13:1},
    "5x":{6:1},
    "5y":{11:1},
    "6x":{3:1},
    "6y":{14:1},
    "7x":{7:1},
    "7y":{10:1},
    "8x":{2:1},
    "8y":{15:1}
}


# for a given lineup and their probabilities (2n entries),
# return the possible outcomes (n entries) and their probabilities
def outputProbs(lineup):
    output = {}
    for n in range(int(len(lineup)/2)):
        currentMatchNum = n+1
        team1Id = str(currentMatchNum)+"x"
        team2Id = str(currentMatchNum)+"y"
        nextMatchNum = math.floor((currentMatchNum+1)/2)
        xOrY = "y" if currentMatchNum%2 == 0 else "x"
        newTeamId = str(nextMatchNum)+xOrY

        output[newTeamId] = {}

        xOptions = lineup[team1Id]
        yOptions = lineup[team2Id]

        for thisX in xOptions:
            for thisY in yOptions:
                comboProb = lineup[team1Id][thisX]*lineup[team2Id][thisY]
                if not thisX in output[newTeamId]:
                    output[newTeamId][thisX] = 0
                if not thisY in output[newTeamId]:
                    output[newTeamId][thisY] = 0
                output[newTeamId][thisX] += comboProb * thisY/(thisX+thisY)
                output[newTeamId][thisY] += comboProb * thisX/(thisX+thisY)

    return output


# for a given lineup (2n entries), calculate one round of randomized results (n entries)
def randomOutput(lineup):
    output = {}
    for n in range(int(len(lineup)/2)):
        currentMatchNum = n+1
        team1Id = str(currentMatchNum)+"x"
        team2Id = str(currentMatchNum)+"y"
        nextMatchNum = math.floor((currentMatchNum+1)/2)
        xOrY = "y" if currentMatchNum%2 == 0 else "x"
        newTeamId = str(nextMatchNum)+xOrY

        rand = random.random()

        output[newTeamId] = {}

        for thisX in lineup[team1Id]:
            for thisY in lineup[team2Id]:
                probOfX = thisY/(thisX+thisY)
                if rand < probOfX:
                    # team 1 wins!
                    output[newTeamId][thisX] = 1
                else:
                    output[newTeamId][thisY] = 1

    return output



# for a given lineup of 16 teams, return the probabilities of the final winner
def finalResult(fullLineup):
    round1Result = outputProbs(fullLineup)
    round2Result = outputProbs(round1Result)
    round3Result = outputProbs(round2Result)
    round4Result = outputProbs(round3Result)
    return round4Result

# for a given lineup of 16 teams, return one randomized winner
def randomFinalResult(fullLineup):
    round1Result = randomOutput(fullLineup)
    round2Result = randomOutput(round1Result)
    round3Result = randomOutput(round2Result)
    round4Result = randomOutput(round3Result)
    return round4Result



# calculate the teamId (e.g. "2y") from the index (1-16)
def teamIdFromIndex(index):
    if index%2 == 0:
        return str(int(index/2))+"y"
    else:
        return str(int((index+1)/2))+"x"

print("\noriginal probabilities of each team winning:")
print(finalResult(bracketInit))


# determine all the possible swap combinations
swapCombos = []
for n in range(16):
    for m in range(16):
        if n<m and not [n+1,m+1] in swapCombos:
            swapCombos.append([n+1,m+1])


maxProb = 0
optimizedBracket = {}
print("\nfind the optimal 'swap':")

# for every possible swap, calculate the new probability of the 2-seed winning
for swap in swapCombos:
    newBracketInit = copy.deepcopy(bracketInit)
    newBracketInit[teamIdFromIndex(swap[0])] = bracketInit[teamIdFromIndex(swap[1])]
    newBracketInit[teamIdFromIndex(swap[1])] = bracketInit[teamIdFromIndex(swap[0])]

    resultFromSwap = finalResult(newBracketInit)

    if maxProb < resultFromSwap['1x'][2]:
        maxProb = resultFromSwap['1x'][2]
        optimizedBracket = newBracketInit
        # print(swap,maxProb)     #  THIS LINE IS THE ONE THAT SCREWED ME UP (I reported the indices)
        print(bracketInit[teamIdFromIndex(swap[0])],bracketInit[teamIdFromIndex(swap[1])],maxProb)


# perform some random trials to validate the outcome
seed2WinCountOriginal = 0
seed2WinCountModified = 0
trialCount = 100000

for n in range(trialCount):
    result = randomFinalResult(bracketInit)
    for winner in result['1x']:
        if winner == 2:
            seed2WinCountOriginal += 1
    result = randomFinalResult(optimizedBracket)
    for winner in result['1x']:
        if winner == 2:
            seed2WinCountModified += 1
print(bracketInit)
print(optimizedBracket)

print("\nrandomized trials (for validation):")
print("original:",seed2WinCountOriginal/trialCount)
print("optimized:",seed2WinCountModified/trialCount)
