package expression;

import java.util.Objects;

public abstract class BinaryOperation extends Expression {
    private Expression left;
    private Expression right;
    private Integer hash = null;

    BinaryOperation(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public String toTree() {
        return "(" + getSymbol() + "," + left.toTree() + "," + right.toTree() + ")";
    }

    @Override
    public int getChildrenCount() {
        return 2;
    }

    public Expression getLeft() {
        return left;
    }

    public Expression getRight() {
        return right;
    }

    @Override
    public Expression[] getChildren() {
        return new Expression[]{left, right};
    }

    @Override
    protected void addDescription(StringBuilder builder) {
        builder.append("(");
        left.addDescription(builder);
        builder.append(getSymbol());
        right.addDescription(builder);
        builder.append(")");
    }

}
