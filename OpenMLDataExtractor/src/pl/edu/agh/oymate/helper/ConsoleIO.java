package pl.edu.agh.oymate.helper;

import java.io.Console;
import java.util.Scanner;

/**
 * Created by Quepas on 2014-11-27.
 */
public class ConsoleIO {

    private static final Console CONSOLE = System.console();
    private static final Scanner SCANNER = new Scanner(System.in);

    public static String input(String msg) {
        if (CONSOLE != null)
            return CONSOLE.readLine(msg);
        else
            return readLineFromScanner(msg);
    }

    public static int inputInt(String msg) {
        System.out.print(msg);
        return SCANNER.nextInt();
    }

    public static String readLineFromScanner(String msg) {
        System.out.print(msg);
        return SCANNER.nextLine();
    }

    public static String inputSecure(String msg) {
        if (CONSOLE != null)
            return String.valueOf(System.console().readPassword(msg));
        else
            return readLineFromScanner(msg);
    }

    public static void puts(String msg) {
        System.out.println(msg);
    }

}
