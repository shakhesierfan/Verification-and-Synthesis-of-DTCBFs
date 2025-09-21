This repository provides the code for the **verification algorithm** presented in the paper 
**"Verification and Synthesis of Discrete-Time Control Barrier Functions"**

The implementation verifies whether a given candidate DTCBF is valid, when a corresponding control policy is unknown. The approach is demonstrated on the cart-pole system. 

---


This code has been tested on Ubuntu 22.04 with Python 3.10 (Anaconda) and the required Python packages (e.g., NumPy, PyInterval, Matplotlib, etc.). In addition, AMPL with the Couenne solver is required. For AMPL installation instructions, please refer to the [AMPL Python documentation](https://dev.ampl.com/ampl/python/index.html).



## 🔹 Citation
If you use this code in your work, please cite the original paper:

@article{Shakhesi2025DTCBFs,
  title     = {Verification and Synthesis of Discrete-Time Control Barrier Functions (DTCBFs)},
  author    = {Erfan Shakhesi and W.P.M.H. (Maurice) Heemels and Alexander Katriniok},
  journal   = {IEEE Transactions on Automatic Control},
  year      = {2025}
}

---

