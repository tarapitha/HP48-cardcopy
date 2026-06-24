# HP48-cardcopy
HP48GX Memory Card Image Copy Utility. Allows direct cloning of card data between memory card slot 1 and slot 2.

All sizes of memory cards are supported, but having 32kB card in one port mandates 32kB card in another port, for copy to succeed.

Utility takes two real numbers from the stack that will specify the copy direction and bank number in slot 2.

E.g.

2: 5  
1: 1  
CARDCOPY  

will copy the 128kB memory bank from port 5 to port 1.   

2: 1  
1: 7  
CARDCOPY  

will copy the whole 128kB memory bank from port 1 to port 7.

The utility copies data only between port 1 and the port with the higher number.  

**-> All the data on the destination port will be overwritten with the source image <-**

Copying the 128kB takes less than one second, 0.8s on my HP48GX.  

The utility only handles copying. If you have installed libraries on the copied port, remove one of the cards as soon as possible to avoid problems due to having same libraries on more than one port.

Running the utility from the user directory is strongly suggested. Especially, do no run in from port 1, this will crash your calculator.
