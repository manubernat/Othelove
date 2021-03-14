require "partie"

-- Callback Löve d'initialisation du jeu
function love.load()
    -- globales pour l'affichage
    LargeurEcran = 800
    HauteurEcran = 800
    MargeDessin = 30
    -- globale de l'état du jeu
    Etat = "menu"   -- menu / solo / duo_local

    -- création du plateau de jeu
    MaPartie = InitialisePartie()

    PetitePolice = love.graphics.newFont("Cabin-Regular.ttf",20)
    MoyennePolice = love.graphics.newFont("Cabin-Regular.ttf",60)
    GrandePolice = love.graphics.newFont("Cabin-Regular.ttf",100)

    love.window.setMode(LargeurEcran, HauteurEcran)
    love.window.setTitle("Othelöve")
end

-- Callback Löve de dessin
-- Note : il n'y a pas d'animation, on n'utilise pas la callback love.update
function love.draw()
    if Etat=="menu" then
        DessineMenu()
    else
        love.graphics.setFont(PetitePolice)
        DessinePartie()
    end
end


-- Callback Löve de relâché du clic gauche
function love.mousereleased( x, y, button, istouch, presses )
    if Etat=="menu" then
        if y>400 and y<400+BtnSolo:getHeight() then
        end
        if y>500 and y<500+BtnDuo:getHeight() then
            Etat = "duo_local"
        end
        if y>700 and y<700+BtnQuitter:getHeight() then
            love.event.quit( 0 )
        end
    else
        OnMouseReleased(x, y, button, istouch, presses)
    end
end

-- Callback Löve de déplacement de la souris
function love.mousemoved( x, y, dx, dy, istouch )
    if Etat=="menu" then
    else
        OnMouseMoved(x, y, dx, dy, istouch)
    end
end

function DessineMenu()
    love.graphics.setFont(GrandePolice)
    love.graphics.printf("Othelöve",MargeDessin,50,LargeurEcran-2*MargeDessin,"center")
    love.graphics.setFont(PetitePolice)
    love.graphics.printf("Un clone de Reversi en Löve/Lua",MargeDessin,150,LargeurEcran-2*MargeDessin,"center")
    love.graphics.printf("version 1.0",MargeDessin,HauteurEcran-MargeDessin,LargeurEcran-2*MargeDessin,"right")

    BtnSolo = love.graphics.newText( MoyennePolice, "" )
    BtnSolo:addf("Partie en solo",LargeurEcran-2*MargeDessin,"center")
    love.graphics.draw(BtnSolo,MargeDessin,400)

    BtnDuo = love.graphics.newText( MoyennePolice, "" )
    BtnDuo:addf("Deux joueurs (en local)",LargeurEcran-2*MargeDessin,"center")
    love.graphics.draw(BtnDuo,MargeDessin,500)

    BtnQuitter = love.graphics.newText( MoyennePolice, "" )
    BtnQuitter:addf("Quitter",LargeurEcran-2*MargeDessin,"center")
    love.graphics.draw(BtnQuitter,MargeDessin,700)
end