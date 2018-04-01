package expression;

import java.util.Objects;

public abstract class Expression {
    private String stringExpression = null;

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
    public boolean equals(Object obj) {
        if (obj == null || !(obj instanceof Expression) || hashCode() != obj.hashCode()) {
            return false;
        }
        return toString().equals(obj.toString());
    }
    //TODO remove from children
}
