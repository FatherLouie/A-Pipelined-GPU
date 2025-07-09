## Multicycle GPU
This repository picks up from the tinyGPU project that can be found here: [tiny-gpu](https://github.com/adam-maj/tiny-gpu/tree/master) 
The tinyGPU project is a multi-cycle implementation of a GPU, which was extensively reviewed and slightly modified and handed out as a project menotred by myself and a co-mentor.
 We then decided to take the project a step further.  
<br>
## Pipelined GPU
Using the multi-cycle GPU as a baseline, all the components were overhauled in order to be able to pipeline the GPU. An entirely new top-level was created from scratch, and can be found in the file 
[pipelined_gpu](https://github.com/FatherLouie/A-Pipelined-GPU/blob/main/Components/pipelined_gpu.sv). This design implements a 4-stage pipelined GPU
<br>
Speculative branch prediction has already been incorporated, and a design to incorporate data-forwarding too has been ideated. A testbench with the sample program to verify the pipelined working is also presented.  
<br>
The FSM from the multi-cycle GPU has been removed, and several components are now combinatorial instead. The program memory has been simplified, while the data memory has been kept as is. Intermediate registers
between each stage (with necessary inputs) have also been implemented. All these can be found in the SystemVerilog files in the folder [Components](https://github.com/FatherLouie/A-Pipelined-GPU/tree/main/Components)
