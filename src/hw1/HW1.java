package hw1;

import axioms.ClassicAxiomsChecker;
import expression.*;
import utils.Pair;
import utils.ExpressionMaker;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class HW1 {

    private static Map<Expression, Integer> hypotheses = new HashMap<>();
    private static Map<Expression, Integer> proved = new HashMap<>();
    private static Map<Expression, List<Pair<Integer, Expression>>> canDeductNotProved = new HashMap<>();
    private static Map<Expression, Pair<Integer, Expression>> canDeductProved = new HashMap<>();

    private static void processImplication(Expression expression, int i) {
        if (!(expression instanceof Implication)) {
            return;
        }
        Implication implication = (Implication)expression;
        Expression a = implication.getLeft();
        Expression b = implication.getRight();

        if (proved.containsKey(a)) {
            canDeductNotProved.put(b, null);
            canDeductProved.put(b, new Pair<>(i, a));
        } else {
            if (canDeductNotProved.get(b) == null) {
                canDeductNotProved.put(b, new ArrayList<>());
            }
            canDeductNotProved.get(b).add(new Pair<>(i, a));
        }

    }

    private static Pair<Integer, Integer> canDeductByMP(Expression expression) {
        if (canDeductProved.containsKey(expression)) {
            Pair<Integer, Expression> prev = canDeductProved.get(expression);
            return new Pair<>(proved.get(prev.getValue()), prev.getKey());
        }
        List<Pair<Integer, Expression>> canDeductExpression = canDeductNotProved.get(expression);
        if (canDeductExpression == null) {
            return null;
        }
        for (Pair<Integer, Expression> pair: canDeductExpression) {
            Expression a = pair.getValue();
            Integer MPNum = pair.getKey();
            Integer proofNum = proved.get(a);
            if (proofNum != null) {
                canDeductNotProved.put(expression, null);
                canDeductProved.put(expression, pair);
                return new Pair<>(proofNum, MPNum);
            }
        }
        return null;
    }

    private static String prepareForProcessing(String s) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            if (!Character.isWhitespace(s.charAt(i))) {
                builder.append(s.charAt(i));
            }
        }
        return builder.toString();
    }

    public static void main(String[] args) throws IOException {
        hypotheses.clear();
        proved.clear();
        canDeductNotProved.clear();
        canDeductProved.clear();

        Path pathToInputFile = Paths.get("input.txt");
        Path pathToOutputFIle = Paths.get("output.txt");
        BufferedReader reader = Files.newBufferedReader(pathToInputFile);
        BufferedWriter writer = Files.newBufferedWriter(pathToOutputFIle);

        String line = reader.readLine().replace("|-", ",");
        String[] hypothesesArray = line.split("," );
        int hypNumber = 1;
        for (int i = 0; i < hypothesesArray.length - 1; i++) {
            String curHyp = prepareForProcessing(hypothesesArray[i]);
            if (!curHyp.isEmpty()) {
                Expression expression = ExpressionMaker.makeExpression(curHyp);
                hypotheses.put(expression, hypNumber++);
            }
        }

        int i = 1;
        while ((line = reader.readLine()) != null) {
            line = prepareForProcessing(line);
            if (line.isEmpty()) {
                continue;
            }
            Expression root = ExpressionMaker.makeExpression(line);
            int axiomNumber;
            Integer hypothesesNum;
            processImplication(root, i);
            writer.write("(" + i + ") " + root.toString() + " ");
            if ((hypothesesNum = hypotheses.get(root)) != null) {
                writer.write("(Предп. " + hypothesesNum + ")\n");
            } else if ((axiomNumber = ClassicAxiomsChecker.checkAll(root)) != 0) {
                writer.write("(Сх. акс. " + axiomNumber + ")\n");
            } else {
                Pair<Integer, Integer> mp = canDeductByMP(root);
                if (mp == null) {
                    writer.write("(Не доказано)\n");
                } else {
                    writer.write("(M.P. " + mp.getValue() + ", " + mp.getKey() + ")\n");
                }
            }
            proved.put(root, i);
            i++;
        }
        reader.close();
        writer.close();
    }
}