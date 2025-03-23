# EDDA

## Experimental designs 

Starting with **completely randomized design**. This is where subjects are randomly assigned to different groups. The key here is that there's no blocking or pairing. For comparing two groups, the t-test comes to mind—either independent t-test if two groups or ANOVA for more than two.  
Parametric and non-parametric options. So, if the data is normal, use t-test or ANOVA; if not, Mann-Whitney U or Kruskal-Wallis.

**Matched pairs design** is when each subject is paired with another, or the same subject is measured under two conditions. The paired t-test is the parametric test here, and the Wilcoxon signed-rank test for non-parametric. 

Next, **randomized block design**. This involves grouping subjects into blocks based on a certain characteristic to reduce variability. For example, blocking by age or gender. The idea is to control for variables that might affect the outcome. The appropriate test here would be the Friedman test for non-parametric data, and maybe repeated measures ANOVA if the data meets parametric assumptions. 

**Repeated measures design** involves measuring the same subjects multiple times under different conditions. The tests here would be repeated measures ANOVA for parametric, and Friedman test for non-parametric. 

**Crossover design** is where subjects receive different treatments in a sequence. The tests here would be similar to repeated measures, like mixed-effects models.

### 1. Completely Randomized Design

​Purpose: Compare groups with no prior blocking or pairing.

​Key Features: Random assignment to groups; independent observations.

​Tests:

​Parametric:

2 groups: Independent t-test

≥3 groups: One-way ANOVA

​Non-Parametric:

2 groups: Mann-Whitney U test

≥3 groups: Kruskal-Wallis test

Example: Testing three diets on randomly assigned participants.

### 2. Randomized Block Design

​Purpose: Control for confounding variables (e.g., age, location) by grouping subjects into blocks.

​Key Features: Blocks reduce variability; treatments applied within blocks.

​Tests:

​Parametric: Two-way ANOVA (block + treatment as factors)

​Non-Parametric: Friedman test (ranks within blocks)

​Example: Comparing fertilizers across different fields (blocks).

### 3.Matched Pairs Design

​Purpose: Compare two treatments within the same or matched subjects.

​Key Features: Dependent observations (paired data).

​Tests:

​Parametric: Paired t-test

​Non-Parametric: Wilcoxon signed-rank test

​Example: Measuring blood pressure before and after a drug in the same patients.

### 4. Repeated Measures Design

​Purpose: Measure the same subjects under different conditions or over time.

​Key Features: Multiple measurements per subject; controls individual variability.

​Tests:

​Parametric: Repeated measures ANOVA

​Non-Parametric: Friedman test

​Example: Testing pain relief under three drugs administered sequentially to the same patients.


### 5. Factorial Design

​Purpose: Study the effect of multiple factors and their interactions.

​Key Features: All combinations of factors tested (e.g., 2x2 design).

​Tests:

​Parametric: Factorial ANOVA

​Non-Parametric: Aligned ranks transformation ANOVA (ART) or permutation tests.

​Example: Testing the effect of diet and exercise on weight loss.


### 6.Crossover Design

​Purpose: Each subject receives all treatments in different sequences.

​Key Features: Controls for individual differences; includes washout periods.

​Tests:

​Parametric: Mixed-effects models

​Non-Parametric: Friedman test (if ordinal data)

​Example: Testing two drugs (A and B) with participants taking A first, then B, and vice versa.



### Key Differences
​Design	​Independence	​Tests	​Use Case

​Completely Randomized	Independent	t-test, ANOVA, Mann-Whitney, Kruskal-Wallis	Simple group comparisons.

​Block/Matched/Repeated	Dependent	Paired t-test, Wilcoxon, Friedman	Control for variability or repeated measurements.

​Factorial	Independent/Dependent	Factorial ANOVA, ART	Study interactions between factors.
