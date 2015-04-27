# Oy-mate

WEKA, HeaRT, OpenML and Auto-WEKA are mates!

## Consists of:
### Machine learning auto-configuration rules

Scripts for generating auto-configuration rules for machine learning algorithms using OpenML's knowledge, wisdom of WEKA and expressiveness of R.

Directory: **ml-auto-configuration-rules**

### Auto-WEKA search space subset

Scripts for runing Auto-WEKA's hyperparameter optimization for given dataset on reduced subset of search space. It based on ranks derived from rules generetad by **ml-auto-configuration-rules** module.

Directory: **autoweka-search-space-subset**

### Dataset generation

Scripts for generating random datasets for WEKA. Using external tools:

* [GenerateData](http://www.generatedata.com/)
* [Mockaroo](https://www.mockaroo.com/)
* [ELKI: DataSetGenerator](http://elki.dbs.ifi.lmu.de/wiki/DataSetGenerator)

Directory: **dataset-generation**

### WEKA rule extraction

Application for extracting rules from rule/decision tree classifiers (JRip, J48 etc.).

Directory: **weka-rule-extraction**

## Tools:

  * [Auto-WEKA](http://www.cs.ubc.ca/labs/beta/Projects/autoweka/)
  * [WEKA](http://www.cs.waikato.ac.nz/ml/weka/)
  * [OpenML](http://openml.org/)
  * [HeaRT](http://ai.ia.agh.edu.pl/wiki/hekate:heart)
