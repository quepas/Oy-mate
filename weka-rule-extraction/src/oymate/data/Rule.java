package oymate.data;

import java.util.ArrayList;

/**
 * Created by Quepas on 2015-04-27.
 */
public class Rule {

    public Rule(Element RHS) {
        LHS = new ArrayList<>();
        this.RHS = RHS;
    }

    public Rule(ArrayList<Element> LHS, Element RHS) {
        this.LHS = LHS;
        this.RHS = RHS;
    }

    private ArrayList<Element> LHS;
    private Element RHS;

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        if (LHS.isEmpty()) {
            builder.append("_");
        } else {
            for (Element lhs : LHS) {
                builder.append(lhs.toString() + "\n");
            }
        }
        builder.append(" => ");
        builder.append(RHS.toString());
        return builder.toString();
    }

}

