import heart.Configuration;
import heart.HeaRT;
import heart.State;
import heart.StateElement;
import heart.alsvfd.Formulae;
import heart.alsvfd.Null;
import heart.alsvfd.SimpleNumeric;
import heart.exceptions.*;
import heart.parser.hmr.HMRParser;
import heart.parser.hmr.runtime.SourceFile;
import heart.xtt.*;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Scanner;

/**
 * Created by Quepas on 2015-05-31.
 */
public class RuleConfigurator {

    public static void main(String[] args) {
        System.out.println("-------------------- RuleConfigurator --------------------");
        System.out.print("Choose DataSet ID: ");
        Scanner scanner = new Scanner(System.in);
        int dataSetId = scanner.nextInt();
        File csvData = new File("D:/Programowanie/Projekty/Oy-mate/ml-auto-configuration-rules/qualities.csv");
        ArrayList<String> csvAttributes = new ArrayList<String>();
        ArrayList<Double> csvValues = new ArrayList<Double>();
        CSVParser csvParser = null;
        try {
            csvParser = CSVParser.parse(csvData, Charset.defaultCharset(), CSVFormat.RFC4180);
        } catch (IOException e) {
            e.printStackTrace();
        }
        for (CSVRecord csvRecord : csvParser ) {
            // check for header
            if (csvRecord.getRecordNumber() == 1) {
                for (int i = 1; i < csvRecord.size(); ++i) {
                    csvAttributes.add(csvRecord.get(i));
                }
            } else if(Integer.valueOf(csvRecord.get(0)) == dataSetId) {
                for (int i = 1; i < csvRecord.size(); ++i) {
                    csvValues.add(Double.valueOf(csvRecord.get(i)));
                }
            }
        }
        SourceFile hmrFile = new SourceFile("D:/Programowanie/Projekty/Oy-mate/ml-auto-configuration-rules/rule.hmr");
        HMRParser parser = new HMRParser();
        State XTTState = new State();
        try {
            parser.parse(hmrFile);
            XTTModel model = parser.getModel();
            LinkedList<Table> tables = model.getTables();
            System.out.println("Tables:");
            for(Table table : tables){
                System.out.println("- " + table.getName());
                LinkedList<heart.xtt.Attribute> concl = table.getConclusion();
                System.out.println("Conlusions:");
                for(heart.xtt.Attribute attr : concl){
                    System.out.println("- " + attr.getName());
                }
                System.out.println("----------------------------------------------------------");
                System.out.println("Rules for table " + table.getName());
                System.out.println("----------------------------------------------------------");

                for(Rule rule : table.getRules()){
                    System.out.print("\nRule " + rule.getId() + ":\n\tif ");
                    for(Formulae formulae : rule.getConditions()){
                        System.out.print(formulae.getAttribute().getName() + " " +
                                         formulae.getOp() + " " +
                                         formulae.getValue() + ", ");
                    }
                    System.out.println("\n==>");
                    for(Decision decision: rule.getDecisions()){
                        System.out.println("\t" + decision.getAttribute().getName() + " set " + decision.getDecision());
                    }
                }
                for (int i = 0; i < csvAttributes.size(); ++i) {
                    String attr = csvAttributes.get(i);
                    Double value = csvValues.get(i);
                    StateElement stateElement = new StateElement();
                    stateElement.setAttributeName(attr);
                    stateElement.setValue(new SimpleNumeric(value));
                    XTTState.addStateElement(stateElement);
                }

                System.out.println("----------------------------------------------------------");
                System.out.println("HeaRT inference process");
                System.out.println("----------------------------------------------------------");
            }

            try{
                HeaRT.fixedOrderInference(model,
                        new String[]{"meta"},
                        new Configuration.Builder()
                                .setInitialState(XTTState)
                                .build());
            }catch(UnsupportedOperationException e){
                e.printStackTrace();
            } catch (BuilderException e) {
                e.printStackTrace();
            } catch (NotInTheDomainException e) {
                e.printStackTrace();
            } catch (AttributeNotRegisteredException e) {
                e.printStackTrace();
            }
            System.out.println("----------------------------------------------------------");
            System.out.println("Printing current state (after inference):");
            System.out.println("----------------------------------------------------------");
            State current = HeaRT.getWm().getCurrentState(model);
            String selectedClass = "None";
            for(StateElement stateElement : current){
                if (!(stateElement.getValue() instanceof Null)) {
                    System.out.println("\t" + stateElement.getAttributeName() + " = " + stateElement.getValue());
                    if (stateElement.getAttributeName().equals("class_attr")) {
                        selectedClass = stateElement.getValue().toString();
                    }
                }
            }
            System.out.println("----------------------------------------------------------");
            System.out.println("Selected class: " + selectedClass);
            System.out.println("----------------------------------------------------------");
        } catch (ParsingSyntaxException e) {
            e.printStackTrace();
        } catch (ModelBuildingException e) {
            e.printStackTrace();
        }
    }
}
