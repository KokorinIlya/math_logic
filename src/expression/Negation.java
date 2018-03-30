package expression;

import java.util.Objects;

public class Negation extends Expression{

    private Expression negated;
    private Integer hash = null;

    public Negation(Expression negated) {
        this.negated = negated;
    }

    public Expression getNegated() {
        return negated;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass() || o.hashCode() != hashCode()) return false;
        Negation negation = (Negation) o;
        return Objects.equals(negated, negation.negated);
    }

    @Override
    public int hashCode() {
        if (hash != null) {
            return hash;
        }
        return hash = Objects.hash(getSymbol(),  negated);
    }

    @Override
    public String toTree() {
        return "(" + getSymbol() + negated.toTree() + ")";
    }

    @Override
    public int getChildrenCount() {
        return 1;
    }

    @Override
    public String getSymbol() {
        return "!";
    }

    @Override
    public Expression[] getChildren() {
        return new Expression[]{negated};
    }

    @Override
    protected void addDescription(StringBuilder builder) {
        builder.append("(");
        builder.append(getSymbol());
        negated.addDescription(builder);
        builder.append(")");
    }
}
