package oymate.classifiers;

import oymate.data.Rule;
import weka.classifiers.trees.J48;

import java.util.ArrayList;

/**
 * Created by Quepas on 2015-04-27.
 */
public class RulesJ48 extends J48 {

    @Override
    public String toString() {
        return this.m_root.toString();
    }

    public ArrayList<Rule> buildRules() {
        // TODO: all
        return new ArrayList<>();
    }
}
