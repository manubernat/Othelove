
function love.load()
    largeurEcran = 800
    hauteurEcran = 800
    marge = 30

    X0 = 2*marge
    X1 = largeurEcran-(2*marge)
    DX = (X1-X0) / 8
    Y0 = 2*marge
    Y1 = hauteurEcran-(2*marge)
    DY = (Y1-Y0) / 8
    
    InitJeu()
    
    love.window.setMode(largeurEcran, hauteurEcran)
    love.window.setTitle("Othelove")
end

function InitJeu()
    p = {}
    p["3,3"] = "B"
    p["4,4"] = "B"
    p["3,4"] = "N"
    p["4,3"] = "N"
    joueur = "N"
    tours = 4
    score = {}
    score["N"] = 2
    score["B"] = 2
end

function love.draw()
    DessineGrille()
    DessinePions()
    local score = "Blancs : "..score["B"].." points - Noirs : "..score["N"].." points - "
    if joueur=="N" then
        love.graphics.print(score.."Au tour des noirs",5,5)
    elseif joueur=="B" then
        love.graphics.print(score.."Au tour des blancs",5,5)
    else
        love.graphics.print(score.."Partie terminée",5,5)
    end
end

function love.update( dt )
end

function DessineGrille()

    for n=0,8 do
        love.graphics.line(X0+n*DX,Y0,X0+n*DX,Y1)
        love.graphics.line(X0,Y0+n*DY,X1,Y0+n*DY)
    end
end

function DessinePions()
    for x=0,7 do
        for y=0,7 do
            if p[x..","..y]=="B" then
                love.graphics.circle("fill",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            elseif p[x..","..y]=="N" then
                love.graphics.circle("line",X0+x*DX+DX/2,Y0+y*DY+DY/2,DX/2.5)
            end
        end
    end
end

function love.mousereleased( x, y, button, istouch, presses )
    if caseX~=-1 and caseY~=-1 then
        if p[caseX..","..caseY]==nil then
            p[caseX..","..caseY]=joueur
            score[joueur] = score[joueur]+1
            if joueur=="B" then
                RetourneCases("N")
                joueur="N"
            else
                RetourneCases("B")
                joueur="B"
            end
            -- Fin de la partie
            tours = tours+1
            if tours==64 then
                joueur=""
            end
        end
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    if x>X0 and x<X1 and y>Y0 and y<Y1 then
        caseX = math.floor((x-X0) / DX)
        caseY = math.floor((y-Y0) / DY)
    else
        caseX = -1
        caseY = -1
    end
end

function RetourneCases(autre)
    RetourneCasesAGauche(autre)
    RetourneCasesADroite(autre)
    RetourneCasesEnHaut(autre)
    RetourneCasesEnBas(autre)
end

function RetourneCasesAGauche(autre)
    -- cherche un pion du joueur à gauche
    local x = caseX-1
    while x>0 and p[x..","..caseY]==autre do
        x = x-1
    end
    -- pas trouvé
    if x==-1 then
        return
    end
    if p[x..","..caseY]==joueur then
        -- retourne les pions dans l'intervalle
        for rx=x+1,caseX-1 do
            p[rx..","..caseY] = joueur
            score[joueur] = score[joueur]+1
            score[autre] = score[autre]-1
        end
    end
end

function RetourneCasesADroite(autre)
    local x = caseX+1
    while x<8 and p[x..","..caseY]==autre do
        x = x+1
    end
    if x==8 then
        return
    end
    if p[x..","..caseY]==joueur then
        for rx=caseX+1,x-1 do
            p[rx..","..caseY] = joueur
            score[joueur] = score[joueur]+1
            score[autre] = score[autre]-1
        end
    end
end

function RetourneCasesEnBas(autre)
    local y = caseY-1
    while y>0 and p[caseX..","..y]==autre do
        y = y-1
    end
    if y==-1 then
        return
    end
    if p[caseX..","..y]==joueur then
        for ry=y+1,caseY-1 do
            p[caseX..","..ry] = joueur
            score[joueur] = score[joueur]+1
            score[autre] = score[autre]-1
        end
    end
end

function RetourneCasesEnHaut(autre)
    local y = caseY+1
    while y<8 and p[caseX..","..y]==autre do
        y = y+1
    end
    if y==8 then
        return
    end
    if p[caseX..","..y]==joueur then
        for ry=caseY+1,y-1 do
            p[caseX..","..ry] = joueur
            score[joueur] = score[joueur]+1
            score[autre] = score[autre]-1
        end
    end
end

