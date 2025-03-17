Compustat data, Production Functions and TFP
Jorge de la Cal Medina

Data:
Use Create_data.do to create a dataset with firm-level financial statements. 
This code is directly from the replication files of De Locker et al (2020). 
Go through the documentation to learn about the variables.

Output elasticities: 
Assuming perfect competition and constant returns to scale then the elasticities equal the share of
revenues paid to each input (see De Locker et al, 2020 and Syverson 2011). 
This is a good first approach to identify the production function. 
In our dataset you can use expenditure variables to get capital and labor elasticities.
Capital expenditure: kexp
Staff expense: xlr
Cost of goods sold: cogs

TFP: 
Once we have estimates for the input elasticities we can construct TFP measures as the ratio of output to input contributions. 
The input contribution is an index that consists of properly weighted individual inputs. 
In case of Cobb-Douglas production function this is just weighted geometric mean of inputs, with output elasticities as weights 
(See Syverson 2011, Section 2.2). 
