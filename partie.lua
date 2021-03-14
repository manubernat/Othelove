-- gestion d'un plateau de Reversi

-- création du plateau de jeu initial
function InitialisePartie()
    -- Globales
    -- coins du plateau de jeu
    X0 = 2*MargeDessin
    X1 = LargeurEcran-(2*MargeDessin)
    Y0 = 2*MargeDessin
    Y1 = HauteurEcran-(2*MargeDessin)
    -- taille des cases
    DX = (X1-X0) / 8
    DY = (Y1-Y0) / 8

    -- affiche les valeurs (= nombre de points potentiels pour le joueur actif) des cases vides
    BAfficheValeurCoups = true

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

-- Affichage du score et des infos de jeu
function DessineInfos()
    local texteScore = "Blancs : "..MaPartie.score["B"].." points - Noirs : "..MaPartie.score["N"].." points - "
    if MaPartie.joueurEnCours=="N" then
        love.graphics.print(texteScore.."Au tour des noirs",5,5)
    elseif MaPartie.joueurEnCours=="B" then
        love.graphics.print(texteScore.."Au tour des blancs",5,5)
    else
        love.graphics.print(texteScore.."Partie terminée",5,5)
    end
end

-- Dessin de la grille du plateau
function DessineGrille()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
    for n=0,8 do
        love.graphics.line(X0+n*DX,Y0,X0+n*DX,Y1)
        love.graphics.line(X0,Y0+n*DY,X1,Y0+n*DY)
    end

    -- affiche les valeurs des coups potentiels
    if BAfficheValeurCoups then
        for x=0,7 do
            for y=0,7 do
                if MaPartie.plateau[x..","..y]==nil then
                    local valeurCoup = EvalueCoup(x, y, Autre())
                    if valeurCoup~=0 then
                        love.graphics.print(valeurCoup,X0+x*DX+DX/2-4,Y0+y*DY+DY/2-6)
                    end
                end
            end
        end
    end

    -- affiche la valeur du coup potentiel de la case survolée ou une croix rouge si le coup est impossible
    if MaPartie.caseX~=-1 and MaPartie.caseY~=-1 then
        local valeurCoupSurvol = EvalueCoup(MaPartie.caseX, MaPartie.caseY, Autre())
        if valeurCoupSurvol>0 then
            love.graphics.print(valeurCoupSurvol,X0+MaPartie.caseX*DX+DX/2-4,Y0+MaPartie.caseY*DY+DY/2-6)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(3)
            love.graphics.line(X0+MaPartie.caseX*DX,Y0+MaPartie.caseY*DY,X0+(MaPartie.caseX+1)*DX,Y0+(MaPartie.caseY+1)*DY)
            love.graphics.line(X0+MaPartie.caseX*DX,Y0+(MaPartie.caseY+1)*DY,X0+(MaPartie.caseX+1)*DX,Y0+MaPartie.caseY*DY)
        end
    end
end

-- Affiche les poins déjà joués
function DessinePions()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)
    for x=0,7 do
        for y=0,7 do
            if MaPartie.plateau[x..","..y]=="B" then
                love.graphics.circle("fill",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            elseif MaPartie.plateau[x..","..y]=="N" then
                love.graphics.circle("line",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            end
        end
    end
end

-- Retourne l'"autre" joueur (ie : pas celui qui est en train de jouer)
function Autre()
    if MaPartie.joueurEnCours=="B" then
        return "N"
    else
        return "B"
    end
end

-- Evalue le score rapporté par un coup
-- Si 0, permet de savoir qu'un coup est valide
function EvalueCoup(evalX, evalY, autre)
    -- si la case est déjà occupée, le coup est nul
    if MaPartie.plateau[evalX..","..evalY]~=nil then
        return 0
    end

    return RetourneCasesDirection(evalX, evalY, autre, -1, 0,  true)
         + RetourneCasesDirection(evalX, evalY, autre, 1,  0,  true)
         + RetourneCasesDirection(evalX, evalY, autre, 0,  -1, true)
         + RetourneCasesDirection(evalX, evalY, autre, 0,  1,  true)
         + RetourneCasesDirection(evalX, evalY, autre, -1, -1, true)
         + RetourneCasesDirection(evalX, evalY, autre, 1,  1,  true)
         + RetourneCasesDirection(evalX, evalY, autre, -1, 1,  true)
         + RetourneCasesDirection(evalX, evalY, autre, 1,  -1, true)
end

-- Retourne les cases prises à l'issue d'un coup
function RetourneCases(autre)
    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, -1, 0, false)
    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, 1, 0, false)

    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, 0, -1, false)
    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, 0, 1, false)

    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, -1, -1, false)
    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, 1, 1, false)

    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, -1, 1, false)
    RetourneCasesDirection(MaPartie.caseX, MaPartie.caseY, autre, 1, -1, false)
end

-- return true si la coordonnées est dans le plateau de jeu
function DansPlateau( x, y )
    return x>=0 and x<8 and y>=0 and y<8
end

-- calcule le score ou retourne les pions pour une prise de caseX,caseY dans la direction px,py
function RetourneCasesDirection( baseX, baseY, autre, px, py, bSimule )
    local x0 = baseX
    local x = x0+px

    local y0 = baseY
    local y = y0+py

    -- recherche la première case qui n'appartient pas à l'autre joueur
    local n = 0
    while DansPlateau(x,y) and MaPartie.plateau[x..","..y]==autre do
        x = x + px
        y = y + py
        n = n + 1   -- nombre de cases d'écart (en valeur absolue)
    end

    -- si on est sorti du plateau
    if not DansPlateau(x,y) then
        return 0    -- pas de point
    end

    -- si la case appartient au joueur en cours
    if MaPartie.plateau[x..","..y]==MaPartie.joueurEnCours then
        if bSimule then
            -- si on simule, il suffit de renvoyer le nombre de cases d'écart
            return n
        else
            -- sinon, retourne les cases et ajuste le score
            for r=1,n do
                MaPartie.plateau[(x0+r*px)..","..(y0+r*py)] = MaPartie.joueurEnCours
                MaPartie.score[MaPartie.joueurEnCours] = MaPartie.score[MaPartie.joueurEnCours]+1
                MaPartie.score[autre] = MaPartie.score[autre]-1
            end
        end
    end

    -- c'est une case vide
    return 0
end

-- Callback de relâché du clic gauche
function OnMouseReleased( x, y, button, istouch, presses )
    if MaPartie.caseX~=-1 and MaPartie.caseY~=-1 then
        if EvalueCoup(MaPartie.caseX, MaPartie.caseY, Autre())==0 then
            return
        end

        if MaPartie.plateau[MaPartie.caseX..","..MaPartie.caseY]==nil then
            MaPartie.plateau[MaPartie.caseX..","..MaPartie.caseY]=MaPartie.joueurEnCours
            MaPartie.score[MaPartie.joueurEnCours] = MaPartie.score[MaPartie.joueurEnCours]+1
            RetourneCases(Autre())
            MaPartie.joueurEnCours=Autre()
            -- Fin de la partie
            MaPartie.nNbTours = MaPartie.nNbTours+1
            if MaPartie.nNbTours==64 then
                MaPartie.joueurEnCours=""
            end
        end
    end
end

-- Callback de déplacement de la souris
function OnMouseMoved( x, y, dx, dy, istouch )
    if x>X0 and x<X1 and y>Y0 and y<Y1 then
        MaPartie.caseX = math.floor((x-X0) / DX)
        MaPartie.caseY = math.floor((y-Y0) / DY)
    else
        -- aucune case survolée
        MaPartie.caseX = -1
        MaPartie.caseY = -1
    end
end

-- Callback de dessin
-- Note : il n'y a pas d'animation, on n'utilise pas la callback love.update
function DessinePartie()
    DessineGrille()
    DessinePions()
    DessineInfos()
end

