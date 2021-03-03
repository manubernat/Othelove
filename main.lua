
function love.load()
    LargeurEcran = 800
    HauteurEcran = 800
    MargeDessin = 30

    X0 = 2*MargeDessin
    X1 = LargeurEcran-(2*MargeDessin)
    DX = (X1-X0) / 8
    Y0 = 2*MargeDessin
    Y1 = HauteurEcran-(2*MargeDessin)
    DY = (Y1-Y0) / 8

    InitJeu()

    love.window.setMode(LargeurEcran, HauteurEcran)
    love.window.setTitle("Othelove")
end

function InitJeu()
    Plateau = {}
    Plateau["3,3"] = "B"
    Plateau["4,4"] = "B"
    Plateau["3,4"] = "N"
    Plateau["4,3"] = "N"
    JoueurEnCours = "N"
    NbTours = 4
    Score = {}
    Score["N"] = 2
    Score["B"] = 2
    CaseX = -1
    CaseY = -1
end

function love.draw()
    DessineGrille()
    DessinePions()
    local score = "Blancs : "..Score["B"].." points - Noirs : "..Score["N"].." points - "
    if JoueurEnCours=="N" then
        love.graphics.print(score.."Au tour des noirs",5,5)
    elseif JoueurEnCours=="B" then
        love.graphics.print(score.."Au tour des blancs",5,5)
    else
        love.graphics.print(score.."Partie terminée",5,5)
    end
end

function DessineGrille()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
    for n=0,8 do
        love.graphics.line(X0+n*DX,Y0,X0+n*DX,Y1)
        love.graphics.line(X0,Y0+n*DY,X1,Y0+n*DY)
    end

    if CaseX~=-1 and CaseY~=-1 then
        local valeurCoup = EvalueCoup(Autre())
        if valeurCoup>0 then
            love.graphics.print(valeurCoup,X0+CaseX*DX+DX/2-4,Y0+CaseY*DY+DY/2-6)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(3)
            love.graphics.line(X0+CaseX*DX,Y0+CaseY*DY,X0+(CaseX+1)*DX,Y0+(CaseY+1)*DY)
            love.graphics.line(X0+CaseX*DX,Y0+(CaseY+1)*DY,X0+(CaseX+1)*DX,Y0+CaseY*DY)
        end
    end
end

function DessinePions()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3)
    for x=0,7 do
        for y=0,7 do
            if Plateau[x..","..y]=="B" then
                love.graphics.circle("fill",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            elseif Plateau[x..","..y]=="N" then
                love.graphics.circle("line",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            end
        end
    end
end

function Autre()
    if JoueurEnCours=="B" then
        return "N"
    else
        return "B"
    end
end

function love.mousereleased( x, y, button, istouch, presses )
    if CaseX~=-1 and CaseY~=-1 then
        if EvalueCoup(Autre())==0 then
            return
        end

        if Plateau[CaseX..","..CaseY]==nil then
            Plateau[CaseX..","..CaseY]=JoueurEnCours
            Score[JoueurEnCours] = Score[JoueurEnCours]+1
            RetourneCases(Autre())
            JoueurEnCours=Autre()
            -- Fin de la partie
            NbTours = NbTours+1
            if NbTours==64 then
                JoueurEnCours=""
            end
        end
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    if x>X0 and x<X1 and y>Y0 and y<Y1 then
        CaseX = math.floor((x-X0) / DX)
        CaseY = math.floor((y-Y0) / DY)
    else
        CaseX = -1
        CaseY = -1
    end
end

-- Evalue le score rapporté par un coup
-- Si 0, permet de savoir qu'un coup est valide
function EvalueCoup(autre)
    -- si la case est déjà occupée, le coup est nul
    if Plateau[CaseX..","..CaseY]~=nil then
        return 0
    end

    return RetourneCasesDirection(autre,-1,0,true)
         + RetourneCasesDirection(autre,1,0,true)
         + RetourneCasesDirection(autre,0,-1,true)
         + RetourneCasesDirection(autre,0,1,true)
         + RetourneCasesDirection(autre,-1,-1,true)
         + RetourneCasesDirection(autre,1,1,true)
         + RetourneCasesDirection(autre,-1,1,true)
         + RetourneCasesDirection(autre,1,-1,true)
end

-- Retourne les cases prises à l'issue d'un coup
function RetourneCases(autre)
    RetourneCasesDirection(autre,-1,0,false)
    RetourneCasesDirection(autre,1,0,false)

    RetourneCasesDirection(autre,0,-1,false)
    RetourneCasesDirection(autre,0,1,false)

    RetourneCasesDirection(autre,-1,-1,false)
    RetourneCasesDirection(autre,1,1,false)

    RetourneCasesDirection(autre,-1,1,false)
    RetourneCasesDirection(autre,1,-1,false)
end

-- return true si la coordonnées est dans le plateau de jeu
function DansPlateau( x, y )
    return x>=0 and x<8 and y>=0 and y<8
end

-- calcule le score ou retourne les pions pour une prise de caseX,caseY dans la direction px,py
function RetourneCasesDirection( autre, px, py, bSimule )
    local x0 = CaseX
    local x = x0+px

    local y0 = CaseY
    local y = y0+py

    -- recherche la première case qui n'appartient pas à l'autre joueur
    local n = 0
    while DansPlateau(x,y) and Plateau[x..","..y]==autre do
        x = x + px
        y = y + py
        n = n + 1   -- nombre de cases d'écart (en valeur absolue)
    end

    -- si on est sorti du plateau
    if not DansPlateau(x,y) then
        return 0    -- pas de point
    end

    -- si la case appartient au joueur en cours
    if Plateau[x..","..y]==JoueurEnCours then
        if bSimule then
            -- si on simule, il suffit de renvoyer le nombre de cases d'écart
            return n
        else
            -- sinon, retourne les cases et ajuste le score
            for r=1,n do
                Plateau[(x0+r*px)..","..(y0+r*py)] = JoueurEnCours
                Score[JoueurEnCours] = Score[JoueurEnCours]+1
                Score[autre] = Score[autre]-1
            end
        end
    end

    -- c'estune case vide
    return 0
end

