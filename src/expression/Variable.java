package expression;

import java.util.Objects;

public class Variable extends Expression {

    private String name;
    private Integer hash = null;

    public Variable(String name) {
        this.name = name;
    }

    @Override
    public String toTree() {
        return name;
    }

    @Override
    public int getChildrenCount() {
        return 0;
    }

    @Override
    public String getSymbol() {
        return "Variable";
    }

    public String getName() {
        return name;
    }

    @Override
    protected void addDescription(StringBuilder builder) {
        builder.append("(").append(name).append(")");
    }

    @Override
    public Expression[] getChildren() {
        return new Expression[0];
    }
}
