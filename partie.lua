-- gestion d'un plateau de Reversi

-- création du plateau de jeu initial
function InitialisePartie()
    local partie = {}

    partie.plateau = {}
    partie.plateau["3,3"] = "B"
    partie.plateau["4,4"] = "B"
    partie.plateau["3,4"] = "N"
    partie.plateau["4,3"] = "N"
    partie.joueurEnCours = "N"
    partie.nNbTours = 4
    partie.score = {}
    partie.score["N"] = 2
    partie.score["B"] = 2
    partie.caseX = -1
    partie.caseY = -1

    return partie
end

