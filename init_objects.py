#Giannelos Stylianos 43828 - Ketsemenidis Eleytherios 18390282

grid = [
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1], 
  [1, 1, 3, 2, 0, 0, 2, 0, 1, 1], 
  [1, 0, 0, 0, 1, 1, 0, 0, 2, 1], 
  [1, 0, 2, 0, 1, 1, 0, 2, 3, 1], 
  [2, 0, 0, 0, 0, 3, 0, 0, 3, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 3, 3, 0, 1, 1, 0, 3, 0, 1],
  [1, 0, 0, 2, 1, 1, 0, 0, 2, 1],
  [1, 1, 2, 0, 2, 0, 2, 0, 1, 1], 
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
]      

for i in range(10): # Εμπόδια με τιμή 1
  for j in range(10):
    if grid[i][j] == 1:
      print('(obstacle_at ' + str(11 - (i + 1)) + ' ' + str(j + 1) + ')')
    
 
for i in range(10): # Καλά φρούτα με τιμή 2
  for j in range(10):   
    if grid[i][j] == 2:
      print('(good_fruit_at ' + str(11 - (i + 1)) + ' ' + str(j + 1) + ')')
    

for i in range(10): # Κακά φρούτα με τιμή 3
  for j in range(10):    
    if grid[i][j] == 3:
      print('(bad_fruit_at ' + str(11 - (i + 1)) + ' ' + str(j + 1) + ')')