package oymate.data;

/**
 * Created by Quepas on 2015-04-27.
 */
public enum Symbol {
    LE("<="),
    GE(">="),
    E("=");

    private String symbol;

    Symbol(String symbol) {
        this.symbol = symbol;
    }

    @Override
    public String toString() {
        return symbol;
    }
}
