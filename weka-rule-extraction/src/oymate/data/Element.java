package oymate.data;

/**
 * Created by Quepas on 2015-04-27.
 */
public class Element {

    private String attribute;
    private Symbol symbol;
    private double numeric;
    private String nominal;
    private boolean isNumeric;
    private boolean isClass;

    public Element(String className) {
        this.isClass = true;
        this.isNumeric = false;
        this.attribute = className;
    }

    public Element(String attribute, Symbol symbol, double numeric) {
        this.isClass = false;
        this.isNumeric = true;
        this.attribute = attribute;
        this.symbol = symbol;
        this.numeric = numeric;
    }

    public Element(String attribute, Symbol symbol, String nominal) {
        this.isClass = false;
        this.isNumeric = false;
        this.attribute = attribute;
        this.symbol = symbol;
        this.nominal = nominal;
    }

    @Override
    public String toString() {
        if (isClass) {
            return attribute;
        } else {
            return attribute + symbol + (isNumeric ? numeric : nominal);
        }
    }
}
