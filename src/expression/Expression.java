package expression;

import java.util.Arrays;
import java.util.Objects;

public abstract class Expression {
    private String stringExpression = null;
    private Integer hash = null;

    public abstract String toTree();

    protected abstract void addDescription(StringBuilder builder);

    public abstract int getChildrenCount();

    public abstract String getSymbol();

    public abstract Expression[] getChildren();

    @Override
    public String toString() {
        if (stringExpression == null) {
            StringBuilder builder = new StringBuilder();
            addDescription(builder);
            stringExpression = builder.toString();
        }
        return stringExpression;
    }

    @Override
    public int hashCode() {
        if (hash == null) {
            hash = toString().hashCode();
        }
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || obj.getClass() != getClass() || obj.hashCode() != hashCode()) {
            return false;
        }
        return toString().equals(obj.toString());
    }
}
