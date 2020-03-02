## UCY_UNIV param.csv LEGENDA

The csv files are composed as follows:

| v_des     | f1        | f2        | f3        |
| ---       | ----      | ---       | ----      |

The linear regression was computed giving slices of the dataset sorted by:

**RADIUS = 1**
- crowdedness = 0
- crowdedness = 1
- crowdedness = 2
- crowdedness >= 3

**RADIUS = 2**
- 0 <= crowdedness < 2
- 2 <= crowdedness < 4
- 4 <= crowdedness < 6
- 6 <= crowdedness < 8
- crowdedness >= 8

**RADIUS = 5**
- 0 <= crowdedness < 5
- 5 <= crowdedness < 10
- 10 <= crowdedness < 15
- 15 <= crowdedness < 20
- 20 <= crowdedness < 25
- 25 <= crowdedness < 30
- crowdedness >= 30