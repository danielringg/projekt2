require 'ruby2d'

set width: 800, height: 500 #sätter fönstrets dimensioner
background = Sprite.new( #skapar bakgrunden först som en sprite så den är längst bak
    'img/pokemon_background2.png',
    width: 800, height: 500,
)
text_background = Sprite.new( #lägger text-bakgrunden ovanför
    'img/text_background.png',
    width: 800, height: 150,
    x: 0, y: 350,
)
class Pokemon #definierar pokemon klassen som jag använder mig av, klassen har 3 inbyggda variabler (name, health och attack_power) och 2 inbyggda funktioner (take_damage och update_attack_power)
    def initialize(name, health, attack_power)
        @name = name
        @health = health
        @attack_power = attack_power
    end
    def name
        @name
    end
    def health
        @health
    end
    def attack_power
        @attack_power
    end
    def take_damage(damage)
        @health -= damage
        if @health < 0
            @health = 0 
        end
    end
    def update_attack_power(new_attack_power)
        @attack_power = new_attack_power
    end
end
def automatic_turn(opponent) #automatic_turn funktionen randomiserar vilken attack som används och kallar därefter på attack funktionen som är under beroende på vilken attack det blir. Eftersom growl inte gör nån damage använder den sig av update_attack_power med outputen av attack().
    rand_attack = rand(0..1)
    if rand_attack == 0
        return attack(:tackle, @bidoof, @bulbasaur)
    elsif rand_attack == 1
        opponent.update_attack_power(attack(:growl, @bidoof, @bulbasaur))
        return 0
    end
end
def attack(attack_id, opponent, player) #attack funktionen tar in ett id på vilken attack det är. efter det räknar den ut damage beroende på spelarens attack_power och returnerar det
    if attack_id == :scratch
        return (2 * player.attack_power)/12 #(jag använder integers och inte floats så det inte står att man gör t.ex. 6.125 damage)
    elsif attack_id == :tackle
        return (1 * player.attack_power)/12
    elsif attack_id == :growl
        return opponent.attack_power - 2 #här returnerar jag inte damage utan det värdet som motståndarens attack_power blir uppdaterad till
    end
end
#pokemon no. 1
@bidoof = Pokemon.new( #Pokemon klassen jag definierade innan använder jag här när variablerna name = "bidoof", health = 59 och attack_power = 45.
    "Bidoof",
    59,
    45,
)
@bidoof_sprite = Sprite.new( #ritar ut sprite-en
    "img/bidoof.png",
    width: 500,
    height: 350,
    x: -50, y: -20,
)
@bidoof_stats_img = Sprite.new( #ritar ut bidoofs hp bar och rutan där dens hp och namn står
    "img/hp_background_full.png",
    width: 350,
    height: 150,
    x: 10, y: 40,
)
bidoof_text = Text.new( #ritar ut texten som står över bidoofs hp. Det här är en egen text eftersom den aldrig uppdateras och är på en annan rad.
    "Bidoof       Lv. 2",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 40, y: 80,
)
bidoof_stats = Text.new( #skapar texten för bidoofs hp
    "HP: #{@bidoof.health}",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 40, y: 100,
)
#pokemon no. 2
#det här är samma sak som för den första men med andra värden
@bulbasaur = Pokemon.new(
    "Bulbasaur",
    45,
    49,
)
@bulbasaur_sprite = Sprite.new(
    'img/bulbasaur.png',
    width: 500,
    height: 350,
    x: 300, y: -140,
)
@bulbasaur_stats_img = Sprite.new(
    "img/hp_background_full.png",
    width: 350,
    height: 150,
    x: 400, y: 100,
)
bulbasaur_text = Text.new(
    "Bulbasaur    Lv. 2",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 430, y: 80,
)
bulbasaur_stats = Text.new(
    "HP: #{@bulbasaur.health}",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 430, y: 100,
)
#battle begins
@text = Text.new( #det här är texten som beskriver vad som händer i spelet
    "What will Bidoof do?",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 50, y: 400,
)
@damage_text = Text.new( #andra raden av förra texten... döpte den till damage_text eftersom jag använder den mest för att skriva hur mycket damage man gjorde
    "",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 50, y: 450,
)
bidoof_attacks = Text.new( #det står här vilka attacks man kan välja på
    "Tackle   Growl",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 500, y: 400,
)
@select_arrow = Sprite.new( #flyttas om man trycker på A eller S, det ser då ut som man väljer en attack, men egentligen beror den valda attacken på vilken knapp (A eller S) man senast tryckte in.
    "img/triangle.png",
    width: 50, height: 30,
    x: 460, y: 395,
)
boom = Sprite.new( #det här är explosionen som spelas när man vinner, jag tog den direkt från ruby2d's exempel-sida.
    'img/boom.png',
    clip_width: 127,
    time: 75,
    x: 460, y: 80
)
#uppdaterar positionen av pilen
@select_arrow_x_position = 460
@select_arrow_y_position = 395
@select_arrow_x_update = 460
@select_arrow_y_update = 395

@menu = "attacks" #just nu är man inne på attack-menyn (det finns bara en meny men om jag ville lägga till nåt mer har jag den här variabeln)
@selected_attack = "scratch" #vilken attack som är vald, uppdateras senare och börjar på scratch eftersom pilen börjar på det
@updated_text = @text.text #jag använder detta för att uppdatera texten i textrutan

@damage = 0 #damage börjar på 0 och uppdateras senare beroende på vilken attack som är vald
@has_attacked = false #blir true efter att man har attackerat och då är det motståndarens tur
player_turn = true #börjar på true eftersom spelaren börjar, blir sen false efter att man har gjort sin runda och efter motståndaren har kört blir den true igen
  
update do #loopen som uppdaterar allt och där allt faktiskt händer
    #uppdatera select-pilens position
    @select_arrow.x = @select_arrow_x_update
    @select_arrow.y = @select_arrow_y_update
    #uppdatera grafikerna för bidoof 
    if (@bidoof.health.to_f / 59) <= 0.0
        @updated_stats_img = "img/hp_background_zero.png"
    elsif (@bidoof.health.to_f / 59) < 0.1
        @updated_stats_img = "img/hp_background_10.png"
    elsif (@bidoof.health.to_f / 59) < 0.3
        @updated_stats_img = "img/hp_background_30.png"
    elsif (@bidoof.health.to_f / 59) < 0.5
        @updated_stats_img = "img/hp_background_50.png"
    elsif (@bidoof.health.to_f / 59) < 0.7
        @updated_stats_img = "img/hp_background_70.png"
    elsif (@bidoof.health.to_f / 59) < 0.9
        @updated_stats_img = "img/hp_background_90.png"
    else
        @updated_stats_img = "img/hp_background_full.png"
    end
    @bidoof_stats_img.remove
    @bidoof_stats_img = Sprite.new(
        @updated_stats_img,
        width: 350,
        height: 150,
        x: 420, y: 200
    )
    bidoof_text.remove
    bidoof_stats.remove
    bidoof_text = Text.new(
    "Bidoof       Lv. 2",
    color: 'black',
    font: 'PublicPixel-z84yD.ttf',
    size: 15,
    x: 460, y: 240,
    )
    bidoof_stats = Text.new(
        "HP: #{@bidoof.health}",
        color: 'black',
        font: 'PublicPixel-z84yD.ttf',
        size: 15,
        x: 460, y: 260,
    )
    #uppdatera grafikerna för bulbasaur
    if (@bulbasaur.health.to_f / 45) <= 0.0
        @updated_stats_img = "img/hp_background_zero.png"
    elsif (@bulbasaur.health.to_f / 45) < 0.1
        @updated_stats_img = "img/hp_background_10.png"
    elsif (@bulbasaur.health.to_f / 45) < 0.3
        @updated_stats_img = "img/hp_background_30.png"
    elsif (@bulbasaur.health.to_f / 45) < 0.5
        @updated_stats_img = "img/hp_background_50.png"
    elsif (@bulbasaur.health.to_f / 45) < 0.7
        @updated_stats_img = "img/hp_background_70.png"
    elsif (@bulbasaur.health.to_f / 45) < 0.9
        @updated_stats_img = "img/hp_background_90.png"
    else
        @updated_stats_img = "img/hp_background_full.png"
    end
    @bulbasaur_stats_img.remove
    @bulbasaur_stats_img = Sprite.new(
        @updated_stats_img,
        width: 350,
        height: 150,
        x: 20, y: 0
    )
    bulbasaur_text.remove
    bulbasaur_stats.remove
    bulbasaur_text = Text.new(
        "Bulbasaur    Lv. 2",
        color: 'black',
        font: 'PublicPixel-z84yD.ttf',
        size: 15,
        x: 60, y: 40,
    )
    bulbasaur_stats = Text.new(
        "HP: #{@bulbasaur.health}",
        color: 'black',
        font: 'PublicPixel-z84yD.ttf',
        size: 15,
        x: 60, y: 60,
    )
    #uppdaterar texten ifall en pokemon dör och tar även bort sprite-en
    if @bidoof.health <= 0
        @updated_text = "Bidoof died"
        @updated_damage_text = "Bulbasaur wins!"
        @text.text = @updated_text
        @damage_text.text = @updated_damage_text
        @bidoof_sprite.remove
    elsif @bulbasaur.health <= 0
        @updated_text = "Bulbasaur died"
        @updated_damage_text = "Bidoof wins!"
        @text.text = @updated_text
        @damage_text.text = @updated_damage_text
        boom.play #spelar en liten animation
        @bulbasaur_sprite.remove
    end

    #spelarens runda börjar
    if player_turn == true
        on :key_down do |event| #tar in inputen som ett event
            if event.key == 'a' #om man trycker på a uppdateras select-pilen och den valda attacken ändras
                @select_arrow_x_update = 460
                @select_arrow_y_update = 395
                if @menu == "attacks"
                    @selected_attack = "scratch"
                end
            elsif event.key == 'd' #flyttar på select-pilen och den valda attacken funkar
                @select_arrow_x_update = 590
                @select_arrow_y_update = 395
                if @menu == "attacks"
                    @selected_attack = "growl"
                end
            elsif event.key == '.' and @menu == "attacks" #om man trycker på punkt så utför man den valda attacken och uppdaterar texten och i growls fall även attack_power
                if @selected_attack == "scratch"
                    @updated_text = "Bidoof used scratch!"
                    @updated_damage_text = "It did #{@damage} damage!"
                    @damage = attack(:scratch, @bulbasaur, @bidoof)
                elsif @selected_attack == "growl"
                    @updated_text = "Bidoof used growl!"
                    @updated_damage_text = "Bulbasaur's attack is decreased!"
                    @bidoof.update_attack_power(attack(:growl, @bulbasaur, @bidoof))
                end
                @has_attacked = true
            end
        end
        @bulbasaur.take_damage(@damage) #bulbasaur tar lika mycket damage som blir returnad i koden ovanför.
        if @has_attacked == true #spelaren har nu attackerat och då är player_turn = false
            player_turn = false
        end
        @damage = 0 #damage blir resettad till 0 igen
        @has_attacked = false
    else
        sleep(1)
        @damage = automatic_turn(@bidoof) #det som returneras av automatic_turn blir damage
        if @damage > 0 #eftersom bulbasaur bara har 2 attacker finns det två utfall: om damage är högre än 0 är det tackle och annars är det growl, eftersom growl returnerar 0 i funktionen automatic_turn()
            @updated_text = "Bulbasaur used tackle!"
            @updated_damage_text = "It did #{@damage} damage!"
        else
            @updated_text = "Bulbasaur used growl!"
            @updated_damage_text = "Bidoof's attack is decreased!"
        end
        @bidoof.take_damage(@damage) #bidoof tar damage
        player_turn = true #det blir spelarens tur
        @damage = 0 #damage resettas till 0
    end
    #uppdaterar textrutan igen
    @text.text = @updated_text
    @damage_text.text = @updated_damage_text
end

#visar allt (sprites, text osv.)
show