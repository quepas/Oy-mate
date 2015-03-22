package pl.edu.agh.oymate.apps;

import pl.edu.agh.oymate.helper.ConsoleIO;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by Quepas on 2015-01-22.
 */
public class TestApp {

    public static void main(String[] args) {
        List<Integer> list = Arrays.asList(1, 2, 3);
        ConsoleIO.puts(list.toString().replace("[","(").replace("]", ")"));
    }
}
