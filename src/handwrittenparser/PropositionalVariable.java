package handwrittenparser;

public class PropositionalVariable extends Token{
    private String name;

    PropositionalVariable(String name) {
        super(Tokens.VARIABLE);
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
