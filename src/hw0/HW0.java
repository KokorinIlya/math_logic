package hw0;

import expression.Expression;
import utils.ExpressionMaker;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class HW0 {

    public static void main(String[] args) throws IOException {
        StringBuilder builder = new StringBuilder();

        Path pathToInputFile = Paths.get("input.txt");
        Path pathToOutputFIle = Paths.get("output.txt");
        BufferedReader reader = Files.newBufferedReader(pathToInputFile);
        BufferedWriter writer = Files.newBufferedWriter(pathToOutputFIle);

        String line = reader.readLine();
        Expression expression = ExpressionMaker.makeExpression(line);
        writer.write(expression.toTree());
        writer.close();
        reader.close();
    }
}
