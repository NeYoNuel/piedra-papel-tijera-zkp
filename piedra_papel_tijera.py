import random
option = ("piedra", "papel", "tijera")

start = True

while start == True:
    puntaje_user = 0
    puntaje_computer = 0
    start = True
    round = 1
    while puntaje_user < 3 and puntaje_computer < 3:
        
        print("Puntaje usuario =>", puntaje_user)
        print("Puntaje computadora =>", puntaje_computer)
        print("")
        
        print("---------")
        print("Ronda ",round)
        print("---------")
        round += 1
        
        user_option = input(" piedra, papel o tijera => ").lower()
        computer_option = random.choice(option)
        
        if not user_option in option:
            print("Opcion no valida")
            start = True

        print("User option =>", user_option)
        print("Computer option =>", computer_option)


        if user_option == computer_option:
            print("Empate")
            
        elif user_option == "papel":
            if computer_option == "piedra":
                print("Ganaste")
                puntaje_user += 1
                
            else:
                print("Perdiste")
                print("La computadora eligio",computer_option)
                puntaje_computer += 1
                
        elif user_option == "tijera":
            if computer_option == "papel":
                print("Ganaste")
                puntaje_user += 1
                
            else:
                print("Perdiste")
                print("La computadora eligio",computer_option)
                puntaje_computer += 1
                
        elif user_option == "piedra":
            if computer_option == "tijera":
                print("Ganaste")
                puntaje_user += 1
                
            else:
                print("Perdiste")
                print("La computadora eligio",computer_option)
                puntaje_computer += 1
                
        print("")
    if puntaje_user == 3:
        print("Ganaste el juego")
    else:
        print("Perdiste el juego")        
    print("")
    start = input("Quieres seguir jugando? si/no => ").lower()
    if start == "si":
        start = True
    else:
        start = False   