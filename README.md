# Automated Warehouse  

This project focuses on developing a sophisticated scheduling algorithm for warehouse robots to optimize product delivery and order fulfillment. Leveraging technologies like robotics, artificial intelligence (AI), and the Internet of Things (IoT), it aims to enhance operational efficiency and accuracy in automated warehouse environments.  

---

## Table of Contents  
- [Abstract](#abstract)  
- [Problem Statement](#problem-statement)  
- [Approach](#approach)  
- [Main Results](#main-results)  
- [Future Work](#future-work)  
- [How to Run the Code](#how-to-run-the-code)  
- [References](#references)  

---

## Abstract  
Automated warehousing represents a significant shift in logistics by integrating advanced technologies. This project addresses the intricate challenge of optimizing robotic coordination for order fulfillment. The algorithm ensures operational efficiency, reduced time, and enhanced accuracy in a grid-based warehouse layout.

---

## Problem Statement  
Modern warehouses rely on autonomous robots to enhance speed and precision. The project aims to develop an algorithm to:  
1. Coordinate robot movements within grid-based warehouses.  
2. Minimize order fulfillment time.  
3. Ensure adherence to constraints like movement limitations, lane identification, and shelf handling rules.

---

## Approach  
Key constraints addressed:  
- Robots can only move vertically or horizontally within a grid.  
- Robots must navigate predefined lanes without conflicts.  
- Efficient lifting and placement of storage units while maintaining order integrity.  

The algorithm was validated using various test cases, showcasing significant improvements in efficiency and adherence to constraints.

---

## Main Results  
- **Test Case 1:** Optimal time: 64 units.  
- **Test Case 2:** Optimal time: 72 units with four stable models.  
- **Test Case 3:** Optimal time: 31 units with 15 stable models.  
- **Test Case 4:** Optimal time: 20 units with 10 stable models.  
- **Test Case 5:** Optimal time: 31 units with 18 stable models.  

---

## Future Work  
- Prioritizing critical deliveries for enhanced resource allocation.  
- Expanding applications to other domains like paramedic services and pharmaceutical logistics.  
- Refining algorithms by integrating state-of-the-art methodologies.

---

## How to Run the Code  
1. Install [Clingo](https://potassco.org/clingo/).  
2. Clone this repository:  
   ```bash
   git clone https://github.com/abhipatel35/Automated-Warehouse-Project.git
   cd Automated-Warehouse-Project
   ```  
3. Run a test case:  
   ```bash
   clingo abhi_solution.asp testcaseX.asp -c n=Y
   ```  
   Replace `X` with the test case number and `Y` with the grid size parameter. (you can look into Report for a reference , I've uploaded screenshots of Command prompt for each TestCases for better Idea.)

---

## References  
- Azadeh, K., de Koster, M.B.M. R., & Roy, D. (2017). Robotized and Automated Warehouse Systems: Review and Recent Developments.  
- Clingo Documentation.  
- CSE579 Lecture Videos by Dr. Joohyung Lee - Arizona State University.  
- I. Niemelä, "Answer Set Programming: A Declarative Approach to Solving Challenging Search Problems."  
 
``` 
