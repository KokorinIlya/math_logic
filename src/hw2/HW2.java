package hw2;

import axioms.ClassicAxiomsChecker;
import expression.Expression;
import expression.Implication;
import hw1.HW1;
import utils.ExpressionMaker;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class HW2 {

    private static Set<Expression> hypotheses = new HashSet<>();
    private static StringBuilder ansBuilder;
    private static Map<Expression, List<Expression>> canProve = new HashMap<>();
    private static Set<Expression> proved = new HashSet<>();

    private static final String aImplA = "A->(A->A)\n" +
            "A->((A->A)->A)\n" +
            "(A->(A->A))->((A->(A->A)->A)->(A->A))\n" +
            "(A->(A->A)->A)->(A->A)\n" +
            "A->A\n";

    private static final String MP = "(A->D_J)->((A->(D_J->D_I))->(A->D_I))\n" +
            "(A->(D_J->D_I))->(A->D_I)\n" +
            "A->D_I\n";


    public static void main(String[] args) throws IOException {
        ansBuilder = new StringBuilder();

        Path pathToInputFile = Paths.get("input.txt");
        Path pathToOutputFile = Paths.get("output.txt");

        BufferedReader reader = Files.newBufferedReader(pathToInputFile);
        Writer writer = Files.newBufferedWriter(pathToOutputFile);

        String line = reader.readLine().replace("|-", ",");
        String[] strHypArray = line.split(",");
        List<Expression> hypList = new ArrayList<>();

        for (int i = 0; i < strHypArray.length - 2; i++) {
            String curHyp = ExpressionMaker.prepareForProcessing(strHypArray[i]);
            if (curHyp.equals("")) {
                continue;
            }
            Expression hyp = ExpressionMaker.makeExpression(curHyp);
            hypList.add(hyp);
        }

        String newHyps = hypList.stream().map(Object::toString).collect(Collectors.joining(","));
        ansBuilder.append(newHyps)
                .append("|-");

        hypotheses.addAll(hypList);

        String aString = ExpressionMaker.prepareForProcessing(strHypArray[strHypArray.length - 2]);
        Expression a = ExpressionMaker.makeExpression(aString);
        ansBuilder.append(a.toString())
                .append("->")
                .append(
                        ExpressionMaker.makeExpression(
                            ExpressionMaker.prepareForProcessing(
                                strHypArray[strHypArray.length - 1]
                            )
                        ).toString())
                .append("\n");

        while ((line = reader.readLine()) != null) {

            line = ExpressionMaker.prepareForProcessing(line);
            if (line.equals("")) {
                continue;
            }
            Expression curExpression = ExpressionMaker.makeExpression(line);
            String curString = curExpression.toString();

            if (curExpression instanceof Implication) {
                Implication curImplication = (Implication)curExpression;
                Expression first = curImplication.getLeft();
                Expression second = curImplication.getRight();
                if (!canProve.containsKey(second)) {
                    canProve.put(second, new ArrayList<>());
                }
                canProve.get(second).add(first);
            }

            if (ClassicAxiomsChecker.checkAll(curExpression) != 0 ||
                    hypotheses.contains(curExpression)) {
                ansBuilder/*.append("case 1: ")*/
                        .append(curString)
                        .append("->(")
                        .append(a.toString())
                        .append("->")
                        .append(curString)
                        .append(")\n");

                ansBuilder.append(curString)
                        .append("\n");

                ansBuilder.append(a.toString())
                        .append("->")
                        .append(curString)
                        .append("\n");
            } else if (curExpression.equals(a)) {
                ansBuilder.append(aImplA.replaceAll("A", a.toString()));
            } else {
                List<Expression> expressions = canProve.get(curExpression);
                for (Expression expression: expressions) {
                    if (proved.contains(expression)) {
                        Implication implication = new Implication(expression, curExpression);
                        ansBuilder
                                .append(
                                        MP.replaceAll("A", a.toString())
                                        .replaceAll("D_J", expression.toString())
                                        .replaceAll("D_I", curString)
                                );
                    }
                }
            }

            proved.add(curExpression);
        }
        writer.write(ansBuilder.toString());
        reader.close();
        writer.close();
    }
}
