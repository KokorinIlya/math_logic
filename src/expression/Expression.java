package expression;

public abstract class Expression {
    public abstract String toTree();

    protected abstract void addDescription(StringBuilder builder);

    public abstract int getChildrenCount();

    public abstract String getSymbol();

    public abstract Expression[] getChildren();

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        addDescription(builder);
        return builder.toString();
    }
}
