package oymate;

import oymate.classifiers.RulesJ48;
import oymate.classifiers.RulesJRip;
import oymate.data.Rule;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

import java.util.ArrayList;

/**
 * Created by Quepas on 2015-04-27.
 */
public class TestApp {

    public static void main(String[] args) throws Exception {
        ConverterUtils.DataSource source = new ConverterUtils.DataSource("./dataset/iris.arff");
        Instances data = source.getDataSet();

        if (data.classIndex() == -1) {
            data.setClassIndex(data.numAttributes() - 1);
        }

        RulesJRip classifier = new RulesJRip();
        classifier.buildClassifier(data);
        ArrayList<Rule> rules = classifier.buildRules();

        // display rules
        for (Rule rule : rules) {
            System.out.println(rule.toString());
        }
    }
}
