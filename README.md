https://hackmd.io/LEQywFmBQK6ZsAfM2WW6tg
## Background
The **Slotted ALOHA** procedure segments the time into slots of a fixed length $\tau$. Every packet transmitted must fit into one of these slots. A packet arriving to be transmitted at any given station must be delayed until the beginning of the next slot. The station can be in either of three states:
-- idle (no ready packet to be transmitted)
-- backlogged (the packet transmitted in the previous slot was failed, and waiting for the next slot to retransmit)
-- transmitting (transmit new packet if the station was in idle state, or  retransmit the failed packet if the station was in backlogged state)
#### Throughput Analysis
An expression for $S$ in terms of $G$ is required. This will be derived for an **infinite** population and a **finite** population of stations.
#### Infinite population case
![](https://i.imgur.com/zWVp6O5.png)
The vulnerable period for Slotted ALOHA is reduced from $2\tau$ to $\tau$ seconds.
$$S=Pr[1\ arrival\ in\  \tau \ seconds]={(\lambda\tau)^1\over 1!}{e^{- \lambda\tau}}={\lambda\tau}{e^{- \lambda\tau}}=Ge^{-G}$$
![](https://i.imgur.com/xBTwt5h.png)
*Fig.5: $S$ vs $G$ for ALOHA and Slotted ALOHA*

Compare this with the Pure Aloha case: $S = Ge^{−2G}$. The maximum throughput for Slotted ALOHA is ${1\over e} ≈ 0.368$ and the maximum occurs for $G = 1$.

#### Collision Probability Analysis
$$Pr[collision]=Pr[>1\ arrival\ in\  \tau \ seconds]$$
$$=1-Pr[0\ arrival\ in\  \tau \ seconds]-Pr[1\ arrival\ in\  \tau \ seconds]$$
$$=1-{e^{-G}}-Ge^{-G}$$
#### Finite population case
In the above we have assumed the number of users is infinite. Here we will revise the model for a finite population and determine under what conditions the infinite population model gives a reasonable approximation.
Consider a network with $M$ independent stations. The input from each station is modelled as a sequence of *independent Bernoulli Trials*
- Let $S_i$ be the probability of station $i$ successfully transmitting a packet in any slot. $1 −S_i$ is the probability of not successfully transmitting a packet.
- Let $G_i$ and $1−G_i$ be the probabilities for attempting and not attempting transmissions respectively

The probability that station $j$ has a successful transmission is the probability that station $j$ is the only station to attempt a transmission in a particular slot. Therefore:
$$S_j=G_j\prod_{i=1,\  i\ne j}^M (1-G_i)	$$
Assuming all stations share the load equally then $S = MS_j$ and $G = MG_j$, therefore:
$$S = G(1 − {G\over M})^{M−1}$$
Note that:
$$\lim_{n\to\infty}[1+{X\over n}]^n=e^X$$	
as $M\to\infty$, $S=Ge^{-G}$ (as before)

For $M$ stations the maximum throughput $S_{max}$ is calculated by differentiating and equating to zero:
$$0 = (1−{G\over M})− G({M− 1\over M})$$
which results in $G = 1$ (as for the infinite case)
$$S_{max} = (1 − {1\over M})^{M−1}$$

Collision Probability is the probability that at least two stations attempt transmission in a particular slot
$$Pr[collision]=1-\prod_{i=1}^M (1-G_i)-G_j\prod_{i=1,\  i\ne j}^M (1-G_i)$$
$$=1-(1 − {G\over M})^{M}-G(1 − {G\over M})^{M−1}$$
## System Model
#### Scenario 1: Infinite-Station
| I/P Parameters    | Value |  
| ----------------- | ------| 
|$M$: # of STAs       | $M\to\infty$  | 
|$T$: # of access cycles| $10^5$  |
|$\lambda$: packet rate| $[0:0.2:18]$  |

#### Variable Data structure
| Variable | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
|    $R$     | random number generated from poisson distribution with mean $\lambda$, represents the number of packets being sent in that timeslot | Integer  | $0$~$\infty$    |
|    $t$     | Access Cycle/ Timeslot ID  | Integer  | $1$~$T$    |
|$success\_pckt$ | the number of successful transmission | Integer  |$0$ ~ $\infty$ |
|$collision\_pckt$ | the number of failed transmission | Integer  |$0$ ~ $\infty$ |

#### Output Data structure
| O/P | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
| $throughput$ | $success\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |
| $collision\_prob$ | $collision\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |

#### Flow Chart
```flow
st=>start: Start
e=>end: End
op=>operation: lambda=0
op1=>operation: success_pckt=0, 
collision_pckt=0
op2=>operation: t=1
op3=>operation: Generate random number from
poisson distribution with 
mean=lambda, assign to R
op3_5=>operation: Collision detected, 
increment collision_pckt
op4=>operation: packet successfully 
transmitted, 
increment success_pckt
op5=>operation: increment t
op6=>operation: calculate throughput 
and collision_prob
for this lambda
op7=>operation: increment 
lambda 
by 0.2
op8=>operation: plot Y:throughput, 
X:lambda
cond=>condition: is R=1?
cond1=>condition: is R>1?
cond2=>condition: is t=T?
cond3=>condition: is lambda=18?

st->op->op1->op2->op3->cond
cond(yes)->op4->cond2
cond(no)->cond1
cond1(yes)->op3_5->cond2
cond1(no)->cond2
cond2(yes)->op6->cond3
cond2(no)->op5->op3
cond3(no)->op7->op1
cond3(yes)->op8->e
```
#### Scenario 2: Finite-Station
| I/P Parameters    | Value |  
| ----------------- | ------| 
|$M$: # of STAs       | $10, 50$  | 
|$T$: # of access cycles| $10^5$  |
|$\lambda$: packet rate| $[0:0.2:8]$  |

#### Variable Data structure
| Variable | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
|    $G_i$     | probability of station $i$ attempting transmission  | Float  | 0~1    |
|    $P_r$     | Random number generated from uniform distribution  | Float  | 0~1    |
|    $m$     | Station ID  | Integer  | 1~M    |
|    $t$     | Access Cycle/ Timeslot ID  | Integer  | 1~T    |
|$pcktThisSlot$ | the number of packets transmitted in slot $t$ | Integer  |$0$ ~ $M$ |
|$success\_pckt$ | the number of successful transmission | Integer  |$0$ ~ $\infty$ |
|$collision\_pckt$ | the number of failed transmission | Integer  |$0$ ~ $\infty$ |

#### Output Data structure
| O/P | Meaning  | Data Type| range   |
| -------- | -------- | -------- |-------- |
| $throughput$ | $success\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |
| $collision\_prob$ | $collision\_pckt\over T$ for each $\lambda$| Vector of Float | $vector\ size=(1, length(\lambda)$, each element has range $0$~$1$ |
#### Timing Diagram
![](https://i.imgur.com/2qugSJD.jpg)
*Fig. 6 Timing Diagram*
- During each timeslot each station will be transmitting packet with probability $G_i={G\over M}$
- The successful transmission happens when there is only one station transmitting the packet
- The input from each station is modelled as a sequence of *independent Bernoulli Trials*
- There is no backoff time, the collided packet will be retransmitted again in the future timeslot, based on probability calculation of each station and *bernoulli trial*. (this is called $thinking\ state$)

#### Flow Chart
```flow
st=>start: Start
e=>end: End
op=>operation: lambda=0
op1=>operation: success_pckt=0, 
collision_pckt=0
op2=>operation: t=1
op2_5=>operation: pcktThisSlot=0
op3=>operation: m=1
op4=>operation: Generate random 
number, 
assign to Pr
op5=>operation: STA is 
transmitting packet
op6=>operation: STA is not 
transmitting
packet
op7=>operation: increment pcktThisSlot
op8=>operation: increment
m
op9=>operation: Collision 
detected, 
increment 
collision_pckt
op10=>operation: packet successfully 
transmitted, 
increment success_pckt
op11=>operation: increment t
op12=>operation: calculate throughput 
and collision_prob
for this lambda
op13=>operation: plot Y:throughput, 
X:lambda
op14=>operation: increment 
lambda 
by 0.2
cond=>condition: is
Pr<Gi?
cond2=>condition: is
m=M?
cond3=>condition: is
pcktThisSlot=1?
cond4=>condition: is
pcktThisSlot>1?
cond5=>condition: is
t=T?
cond6=>condition: is
lambda=8?

st->op->op1->op2->op2_5->op3->op4->cond
cond(yes)->op5->op7->cond2
cond(no)->op6->cond2
cond2(no)->op8->op4
cond2(yes)->cond3
cond3(yes)->op10->cond5
cond3(no)->cond4
cond4(yes)->op9->cond5
cond4(no)->cond5
cond5(no)->op11->op2_5
cond5(yes)->op12->cond6
cond6(yes)->op13->e
cond6(no)->op14->op1

```
## Numerical Results
#### Scenario 1: Infinite-Station
![](https://i.imgur.com/En8AMPj.png)
*Fig. 7 Average Throughput of infinite-station slotted ALOHA*
![](https://i.imgur.com/e3vcxYm.png)
*Fig. 8 Collision probability of infinite-station slotted ALOHA*

Figures 7, and 8 illustrated simulation results and the analytical result of the throughput and the collision probability, of infinite-station slotted ALOHA obtained from Equations
$$S=Ge^{-G}$$$$Pr[Collision]=1-{e^{-G}}-Ge^{-G}$$ for $G=0$ to $18$ and $T=10^5$.

#### Scenario 2: Finite-Station
![](https://i.imgur.com/BQdroks.png)
*Fig. 9 Average Throughput of finite-station slotted ALOHA*
![](https://i.imgur.com/kp7YO9N.png)
*Fig. 10 Collision Probability of finite-station slotted ALOHA*

Figures 9, and 10 illustrated simulation results and the analytical result of the throughput and the collision probability, of finite-station slotted ALOHA for $M = 10$ and $50$, for $G$ = $0$ to $8$ and $T=10^5$.

from figure 9 we know that lower number of stations will make the maximum throughput higher, but it will decay to zero faster. And also from figure 10 we know that lower number of stations will make the collision probability approaches 1 faster.
