# HP48-cardcopy
HP48GX Memory Card Image Copy Utility. Allows direct cloning of card data between memory card slot 1 and slot 2.  
Copying the 128kB takes less than one second, 0.8s on my HP48GX.  

# Usage
The utility copies data only between port 1 and the port with the higher number.  
It takes two reals from the stack, level 2 specifies source and level 1 destination.  

2: 5  
1: 1  
CARDCOPY  

will copy the memory bank from port 5 to port 1.   

2: 1  
1: 7  
CARDCOPY  

will copy the whole memory bank from port 1 to port 7.

**Be aware -> All the data on the destination port will be overwritten with the source memory port image.**

# Requirements
- Only HP48GX is supported
- The utility should be run from the System RAM area.  
- All sizes of memory cards are supported, but having 32kB card in one port mandates 32kB card in another port or the copy will not be done.
- The utility only handles copying, not resolving the possible system conflicts due to having the same libraries on multiple cards or overwriting the card with attatched libraries.
