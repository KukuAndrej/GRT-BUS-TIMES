# Grand River Transit Bus Times

For all those in the Waterloo/Kitchener area, this program is used as a quicker alternative to searching up the bus times for a stop that's part of the GRT. 

## Set-Up

Once you have the file, add permissions to run the file

**Example**
```
chmod +x pathtofile/grt.sh
```

Add an alias in your **.bashrc** file to run the program without having to specify the directory everytime 
```
alias grt="pathtofile/grt.sh"
```

## Usage

It takes 1 argument which is the bus stop number
```
grt 2675
```
This returns 2 colums labeled time and route with all current bus times

**OR**

It takes 2 argument where the first argument is the bus stop number and the second is a bus number
```
grt 2675 9
```
This returns 2 colums labeled time and route with all current bus times
