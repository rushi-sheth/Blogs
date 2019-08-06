
## Hypothesis Testing

- [What is hypothesis testing?](#intro)
- [Types of statistic](#types1)
    - t-statistic
    - z-statistic
    - f-statistic    
- [Types of Tests](#types2)
  - [Parametric](#parametric) 
      - One Sample t-test
      - Pooled t-test
      - Paired t-test
      - Welch Test
      - Anova
  - [Non-Parametric](#nonparametric)
      - Wilcoxon one sample test
      - Chi Square Goodness of fit
      - Chi Square Test of Independence

<a id="intro"></a>
### What is hypothesis testing?

Hypothesis testing can be simply defined as,"___A decision making process which uses statistical inference to accept or reject an assumption about some population parameter___."
<br><Br>
A hypothesis can be defined as an statement regarding the parameter that we would like to test.<br> The basic process of hypothesis testing is as follows: 
1. __State the null hypothesis $(H_{0})$__ - It proposes the relation between the sample and population that we are trying to reject.
2. __State the Alternative hypothesis $(H_{a})$__ - This is a proposed statement contrary to the null hypothesis.
3. __Decide the Significance level__ - A significance level is the probability that the observed value of statistic isn't due to chance or random noise. The value is to be decided by the researcher prior to testing.
4. __Decide the test statistic__: Once the setup is completed, we then decide the test statistic based on the data and the goal of the hypothesis.
5. __Decision making__: The rejection or acceptance of the hypothesis can be done in two possible ways. 
    - Decision using __critical regions__: In this method, we compare the calculated statistic with the critical region in the distribution.
    - Decision using __p value__: Using this method, we do not need to identify the critical region. Instead, we calculate the probability of getting the observed statistic (from previous step) if the null hypothesis were true. The probability can also be interpreted as the probability that our results are due to some random noise. If greater than our significance level, we fail to reject the null. 

**One Sided vs Two sided Tests**

<a id="type1"></a>
### Types of Statistics

Depending on the data and the goal of the experiment, we can select what kind of statistic is to be used. Three commonly used statistic are:
 - z-statistic - 
     - **Data**: Large sample size (>30) and known population standard deviation
     - **Goal**: Testing mean against standard or between two groups 
 
 - t-statistic - 
     - **Data**: Small sample sizes (<30) and unknown population standard deviation
     - **Goal**: Testing mean against standard or between two groups 
 
 - f-statistic-
     - **Data**: More than 2 groups
     - **Goal**: ANOVA stands for Analysis of Variance. This test is used to compare means between 2 or more unrelated groups. 

<a id="types2"></a>
### Types of tests

The testing can further be divided into parametric and non parametric tests. 

A parametric test assumes that the data has some underlying distribution, usually normal. A short summary table is given below comparing various testing parameters and hypothesis.


<a id="parametric"></a>
### Parametric



<img src='images\stats.png' >


In this exercise, we will go through how to do hypothesis testing in R for the following tests:
 - One sample t-test
 - Pooled t-test
 - Paired t-test


Let's come up with a hypothetical situation for better understanding of these tests.
<br><br>
**Problem Statement**<br>
Due to global warming and climate crisis, a group of middle school students worried about their future,
take up an experiment to check and promote tree plantation. They live in state called "Concrete jungle" with 8 towns which are identical to each other in all aspects, (size, population, plantation area etc.) 

- The state government body claims that on an average there were 150 trees planted every week in each town 
- Students think this is not true and the actual mean is less than 150. They accompany the plantation supervisors in their town for 10 weeks and collect the weekly data
- Due to weather and other reasons, they observe that every week the number is not consistent with 150.

***


##### One Sample t-test

__How do we verify if the number of trees are actually 150?__

This is one type of problem where we can use one sample t-test. Since all the towns are identical and independent of each other, we can use a t-test.

$$H_{0} = \mu_{\text{trees planted every week}}=150 \\ H_{a} = \mu_{\text{trees planted every week}}<150 $$

Sample size (n) = 10 (since 10 weeks of data)<br>
Population mean = 150 (claim of the government)



```R
set.seed(123)
student_town = data.frame(week=1:10,trees = as.integer(rnorm(10,mean = 145, sd = 5)))
student_town
```


<table>
<thead><tr><th scope=col>week</th><th scope=col>trees</th></tr></thead>
<tbody>
	<tr><td> 1 </td><td>142</td></tr>
	<tr><td> 2 </td><td>143</td></tr>
	<tr><td> 3 </td><td>152</td></tr>
	<tr><td> 4 </td><td>145</td></tr>
	<tr><td> 5 </td><td>145</td></tr>
	<tr><td> 6 </td><td>153</td></tr>
	<tr><td> 7 </td><td>147</td></tr>
	<tr><td> 8 </td><td>138</td></tr>
	<tr><td> 9 </td><td>141</td></tr>
	<tr><td>10 </td><td>142</td></tr>
</tbody>
</table>



First we decide the significance level $\alpha$. 
<br>$$\alpha = 0.05$$

Next, we check for normality of the data. This can be done using Shapiro-Wilk test or plots like QQ.


```R
shapiro.test(student_town)
```


    
    	Shapiro-Wilk normality test
    
    data:  student_town
    W = 0.92372, p-value = 0.389
    


The null hypothesis for shapiro test is "Data is distributed normally".<br>Since the p-value is greater than 0.05, we cannot reject the null hypothesis.


```R
library("ggplot2")
library(repr)
```


```R
options(repr.plot.width=2, repr.plot.height=2)
qplot(sample=student_town)+stat_qq_line()
```


![png](output_19_0.png)


The data on the qq plot follow a kind of straight line, so we can confirm its normally distributed.

Now, we perform the student one sided t test.
<br><br>Why one sided?<br>Since we are concerned with the direction of the relationship, i.e., testing only for less than mean, we use one sided.



```R
t.test(student_town$trees,mu=150,alternative="less")
```


    
    	One Sample t-test
    
    data:  student_town$trees
    t = -3.4573, df = 9, p-value = 0.003596
    alternative hypothesis: true mean is less than 150
    95 percent confidence interval:
         -Inf 147.5571
    sample estimates:
    mean of x 
        144.8 
    


**We can observe that the p-value is less than 0.05 (significance level $\alpha$), so we reject the null hypothesis that mean plantation is 150 per week.**

***

##### Pooled t-test (2-sample t-test)

As the news of the student experiment spread, another student group in the neighboring state "Nature Lovers" undertook the same experiment. But, the Nature lovers state has is not related to the concrete jungle state in any way. It has different land size, plantation cover etc. 

Such kind of questions can be solved using a pooled or 2 sample t-test. We test for the equal means.<br><br>
$$H_{0} = \mu_{concrete} = \mu_{nature} $$
$$H_{a} =\mu_{concrete} \neq \mu_{nature} $$


```R
set.seed(123)
pooled = data.frame(week=1:10,Concrete_jungle = as.integer(rnorm(10,145,sd=5)),Nature_lovers=as.integer(rnorm(10,155,sd=6)))
pooled
```


<table>
<thead><tr><th scope=col>week</th><th scope=col>Concrete_jungle</th><th scope=col>Nature_lovers</th></tr></thead>
<tbody>
	<tr><td> 1 </td><td>142</td><td>162</td></tr>
	<tr><td> 2 </td><td>143</td><td>157</td></tr>
	<tr><td> 3 </td><td>152</td><td>157</td></tr>
	<tr><td> 4 </td><td>145</td><td>155</td></tr>
	<tr><td> 5 </td><td>145</td><td>151</td></tr>
	<tr><td> 6 </td><td>153</td><td>165</td></tr>
	<tr><td> 7 </td><td>147</td><td>157</td></tr>
	<tr><td> 8 </td><td>138</td><td>143</td></tr>
	<tr><td> 9 </td><td>141</td><td>159</td></tr>
	<tr><td>10 </td><td>142</td><td>152</td></tr>
</tbody>
</table>




```R
shapiro.test(pooled$Concrete_jungle)
shapiro.test(pooled$Nature_lovers)
```


    
    	Shapiro-Wilk normality test
    
    data:  pooled$Concrete_jungle
    W = 0.92788, p-value = 0.4274
    



    
    	Shapiro-Wilk normality test
    
    data:  pooled$Nature_lovers
    W = 0.95262, p-value = 0.6996
    


Both the data exhibit normal distribution


```R
t.test(pooled$Concrete_jungle,pooled$Nature_lovers,var.equal = TRUE)
```


    
    	Two Sample t-test
    
    data:  pooled$Concrete_jungle and pooled$Nature_lovers
    t = -4.4775, df = 18, p-value = 0.0002911
    alternative hypothesis: true difference in means is not equal to 0
    95 percent confidence interval:
     -16.161412  -5.838588
    sample estimates:
    mean of x mean of y 
        144.8     155.8 
    


We can observe that the p-value is less than 0.05, which means that the means of both the groups are not same. We can further investigate to understand if the nature lovers have higher or lesser number of trees planted using a **one sided t-test**.

$$H_{0} = \mu_{concrete} - \mu_{nature} = 0$$
$$H_{a} =\mu_{concrete}-\mu_{nature} < 0  $$


```R
t.test(pooled$Concrete_jungle,pooled$Nature_lovers,var.equal = TRUE,alternative = 'less')
```


    
    	Two Sample t-test
    
    data:  pooled$Concrete_jungle and pooled$Nature_lovers
    t = -4.4775, df = 18, p-value = 0.0001456
    alternative hypothesis: true difference in means is less than 0
    95 percent confidence interval:
          -Inf -6.739862
    sample estimates:
    mean of x mean of y 
        144.8     155.8 
    


**From the above p value, we can reject the null hypothesis that both the means are equal. Instead, the natural lovers have higher mean as compared to the concrete jungle.**

***

##### Paired t-test

After observing that the number of trees planted are less than 150, the students of Concrete jungle protest and force the government to pass new regulations. The new regulations now fine the if they do not show any improvement. How do we know if there is an effect of the regulation? <br><br>
We can identify this using paired t-test.

In a paired t-test, same subjects are observed twice. Once before a treatment and again after the treatment. 

$$H_{0} = \mu_{before} - \mu_{after} = 0$$
$$H_{a} = \mu_{before} - \mu_{after} < 0 \;\;\; \text{i.e, improvement}$$ 


```R
set.seed(123)
paired = data.frame(state = 1:10,trees_planted_before =as.integer(rnorm(10,145,sd=5)),trees_planted_after =as.integer(rnorm(10,149,sd=5)))
paired                    
```


<table>
<thead><tr><th scope=col>state</th><th scope=col>trees_planted_before</th><th scope=col>trees_planted_after</th></tr></thead>
<tbody>
	<tr><td> 1 </td><td>142</td><td>155</td></tr>
	<tr><td> 2 </td><td>143</td><td>150</td></tr>
	<tr><td> 3 </td><td>152</td><td>151</td></tr>
	<tr><td> 4 </td><td>145</td><td>149</td></tr>
	<tr><td> 5 </td><td>145</td><td>146</td></tr>
	<tr><td> 6 </td><td>153</td><td>157</td></tr>
	<tr><td> 7 </td><td>147</td><td>151</td></tr>
	<tr><td> 8 </td><td>138</td><td>139</td></tr>
	<tr><td> 9 </td><td>141</td><td>152</td></tr>
	<tr><td>10 </td><td>142</td><td>146</td></tr>
</tbody>
</table>



Starting with selection of alpha.
$$\alpha = 0.05$$


```R
shapiro.test(paired$trees_planted_before)
shapiro.test(paired$trees_planted_after)
```


    
    	Shapiro-Wilk normality test
    
    data:  paired$trees_planted_before
    W = 0.92788, p-value = 0.4274
    



    
    	Shapiro-Wilk normality test
    
    data:  paired$trees_planted_after
    W = 0.95009, p-value = 0.6695
    


Both the data are following normal distribution, we can proceed with the t test


```R
t.test(paired$trees_planted_before,paired$trees_planted_after,paired = TRUE,alternative = 'less')
```


    
    	Paired t-test
    
    data:  paired$trees_planted_before and paired$trees_planted_after
    t = -3.4364, df = 9, p-value = 0.003716
    alternative hypothesis: true difference in means is less than 0
    95 percent confidence interval:
          -Inf -2.239468
    sample estimates:
    mean of the differences 
                       -4.8 
    


**We observe that the p-value is less than 0.05 along with a negative mean of differences and thus we reject the null hypothesis. There is an improvement due to regulations.**
***

<a id="nonparametric"></a>
### Non Parametric

A non-parametric test is the one in which the data does not have any underlying distribution. 

Types: 
- __Chi Square goodness of fit__: Tests if the data is from a particular distribution
- __Chi Square test of independence__: Tests if the variables are coming from the same population

##### Chi Square goodness of fit

This is test is used to identify if the observed values are from a particular distribution. This is done by comparing the observed and the expected values. The test statistic used is chi square ($\chi^{2}$). 

$$
\chi^{2}=\Sigma \frac{(Observed-Expected)^{2}}{Expected}
$$


**Problem Statement**

A chips manufacturing company has decided to promote health awareness. Instead of packing fried chips, the company now claims that they mix baked chips,fried chips and almonds in equal amounts by weight. To verify this, a boy buys the new packet of chips and found the following weights:

- baked chips: 28gm
- fried chips: 35gm
- almonds :37gm

Can we verify if this proportion is still equal?

$$H_{0}: \text{The observed values are equal to the expected values} \\
H_{a}: \text{The observed values are not equal to the expected values}$$


Significance Level : $$\ alpha =0.05$$


```R
packet = data.frame(Item = c('Baked','Fried','Almonds'),Weight = c(28,35,37))
packet
```


<table>
<thead><tr><th scope=col>Item</th><th scope=col>Weight</th></tr></thead>
<tbody>
	<tr><td>Baked  </td><td>28     </td></tr>
	<tr><td>Fried  </td><td>35     </td></tr>
	<tr><td>Almonds</td><td>37     </td></tr>
</tbody>
</table>




```R
chisq.test(packet$Weight,p=c(1/3,1/3,1/3))
```


    
    	Chi-squared test for given probabilities
    
    data:  packet$Weight
    X-squared = 1.34, df = 2, p-value = 0.5117
    


**Since the p-value is greater than the significance level, we cannot reject the null hypothesis. The packet has equal amounts of weight**

##### Chi Square test of independence

Test of independence is used to identify any association between two variables. 

Continuing with the above example, let's assume we get three packets each from morning shift, evening shift and night shift at the manufacturing facility. Test of independence helps us identify if there is any association between shift and weights in the packet.

$$H_{0} :\text{ There is no relation between the shifts and the weights packed }\\
H_{a}: \text{There is some relation between the shifts and the weights}$$


```R
shift_data = data.frame(Shift= c("Morning","evening","night"),Baked = c(33,35,32),Fried=c(33,43,30),Almond=c(33,29,44),row.names = 1)
shift_data
```


<table>
<thead><tr><th></th><th scope=col>Baked</th><th scope=col>Fried</th><th scope=col>Almond</th></tr></thead>
<tbody>
	<tr><th scope=row>Morning</th><td>33</td><td>33</td><td>33</td></tr>
	<tr><th scope=row>evening</th><td>35</td><td>43</td><td>29</td></tr>
	<tr><th scope=row>night</th><td>32</td><td>30</td><td>44</td></tr>
</tbody>
</table>




```R
test = chisq.test(shift_data)
test
```


    
    	Pearson's Chi-squared test
    
    data:  shift_data
    X-squared = 5.682, df = 4, p-value = 0.2242
    



```R
test$observed
```


<table>
<thead><tr><th></th><th scope=col>Baked</th><th scope=col>Fried</th><th scope=col>Almond</th></tr></thead>
<tbody>
	<tr><th scope=row>Morning</th><td>33</td><td>33</td><td>33</td></tr>
	<tr><th scope=row>evening</th><td>35</td><td>43</td><td>29</td></tr>
	<tr><th scope=row>night</th><td>32</td><td>30</td><td>44</td></tr>
</tbody>
</table>




```R
round(test$expected,2)
test
```


<table>
<thead><tr><th></th><th scope=col>Baked</th><th scope=col>Fried</th><th scope=col>Almond</th></tr></thead>
<tbody>
	<tr><th scope=row>Morning</th><td>31.73</td><td>33.63</td><td>33.63</td></tr>
	<tr><th scope=row>evening</th><td>34.29</td><td>36.35</td><td>36.35</td></tr>
	<tr><th scope=row>night</th><td>33.97</td><td>36.01</td><td>36.01</td></tr>
</tbody>
</table>




    
    	Pearson's Chi-squared test
    
    data:  shift_data
    X-squared = 5.682, df = 4, p-value = 0.2242
    


Since the p-value is 0.2242, which is greater than 0.05, we cannot reject the null hypothesis. There is no relationship between shift and the packaging weights.

***

#### Other tests

##### Wilcoxon One Sample t-test

This is non-parametric extension of one-sample t-test. It is to be used when the data does not follow normal distribution or has outliers.

##### ANOVA

ANOVA is a parametric type of hypothesis testing. It is used to compare the means of multiple groups. The hypothesis for ANOVA is:

$$H_{0}= \mu_{0} =\mu_{1}=\mu_{2}=..=\mu_{n} \\
H_{a} =\text{ Means are not equal}$$

The test only gives us an answer to if the means are equal or not. It does not identify which group is different. 
