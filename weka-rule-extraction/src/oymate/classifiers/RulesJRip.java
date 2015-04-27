package oymate.classifiers;

import oymate.data.Element;
import oymate.data.Symbol;
import weka.classifiers.rules.JRip;
import weka.classifiers.rules.Rule;
import weka.core.Attribute;
import weka.core.Instances;

import java.util.ArrayList;

/**
 * Created by Quepas on 2015-04-27.
 */
public class RulesJRip extends JRip {

    private Attribute classAttr;
    private ArrayList<oymate.data.Rule> rules;

    public void setClassAttribute(Attribute classAttr) {
        this.classAttr = classAttr;
    }

    @Override
    public void buildClassifier(Instances instances) throws Exception {
        super.buildClassifier(instances);
        this.classAttr = instances.classAttribute();
    }

    public ArrayList<oymate.data.Rule> buildRules() {
        rules = new ArrayList<>();

        for (Rule elem : getRuleset()) {
            JRip.RipperRule ripperRule = (JRip.RipperRule) elem;
            ArrayList<Element> LHS = new ArrayList<>();
            for (JRip.Antd antd : ripperRule.getAntds()) {
                String attrName = antd.getAttr().name();
                if (antd instanceof JRip.NumericAntd) {
                    Symbol symbol = (antd.getAttrValue() == 0 ? Symbol.LE : Symbol.GE);
                    double value = ((JRip.NumericAntd)antd).getSplitPoint();
                    LHS.add(new Element(attrName, symbol, value));
                } else if (antd instanceof JRip.NominalAntd) {
                    String value = antd.getAttr().value((int) antd.getAttrValue());
                    LHS.add(new Element(attrName, Symbol.E, value));
                }
            }
            Element RHS = new Element(classAttr.value((int)ripperRule.getConsequent()));
            rules.add(new oymate.data.Rule(LHS, RHS));
        }
        return rules;
    }
}
