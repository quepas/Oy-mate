import heart.Configuration;
import heart.HeaRT;
import heart.State;
import heart.StateElement;
import heart.alsvfd.Null;
import heart.alsvfd.SimpleNumeric;
import heart.exceptions.*;
import heart.parser.hmr.HMRParser;
import heart.parser.hmr.runtime.SourceFile;
import heart.xtt.Table;
import heart.xtt.XTTModel;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Quepas on 2015-06-16.
 */
public class MetaAttrMatcher {

    private State XTTState = new State();
    private XTTModel model;
    private List<Table> tables = new LinkedList<Table>();
    private List<String> csvAttributes = new ArrayList<String>();
    private List<CSVRecord> csvRecords = new ArrayList<CSVRecord>();

    public MetaAttrMatcher(String hmrRulesFileName, String qualitiesCSVFileName) throws IOException {
        SourceFile hmrFile = new SourceFile(hmrRulesFileName);
        File csvData = new File(qualitiesCSVFileName);
        HMRParser parser = new HMRParser();
        try {
            parser.parse(hmrFile);
            model = parser.getModel();
            tables = model.getTables();
        } catch (ParsingSyntaxException e) {
            e.printStackTrace();
        } catch (ModelBuildingException e) {
            e.printStackTrace();
        }
        CSVParser csvParser = null;
        try {
            csvParser = CSVParser.parse(csvData, Charset.defaultCharset(), CSVFormat.RFC4180);
        } catch (IOException e) {
            e.printStackTrace();
        }
        csvRecords = csvParser.getRecords();
        for (CSVRecord csvRecord : csvRecords ) {
            // check for header
            if (csvRecord.getRecordNumber() == 1) {
                for (int i = 1; i < csvRecord.size(); ++i) {
                    csvAttributes.add(csvRecord.get(i));
                }
                break;
            }
        }
        csvRecords.remove(0);
    }

    public void InitState(long dataSetId) {
        XTTState = new State();
        ArrayList<Double> csvValues = new ArrayList<Double>();
        for (CSVRecord csvRecord : csvRecords) {
            if (Integer.valueOf(csvRecord.get(0)) == dataSetId) {
                for (int i = 1; i < csvRecord.size(); ++i) {
                    csvValues.add(Double.valueOf(csvRecord.get(i)));
                }
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
    }

    public String Inference() {
        try {
            HeaRT.fixedOrderInference(model,
                    new String[]{"meta"},
                    new Configuration.Builder()
                            .setInitialState(XTTState)
                            .build());
        } catch (UnsupportedOperationException e) {
            e.printStackTrace();
            System.exit(0);
        } catch (BuilderException e) {
            e.printStackTrace();
        } catch (NotInTheDomainException e) {
            e.printStackTrace();
        } catch (AttributeNotRegisteredException e) {
            e.printStackTrace();
        }

        State current = HeaRT.getWm().getCurrentState(model);
        String selectedClass = "None";
        for(StateElement stateElement : current){
            if (!(stateElement.getValue() instanceof Null)) {
                if (stateElement.getAttributeName().equals("class_attr")) {
                    selectedClass = stateElement.getValue().toString();
                }
            }
        }
        return selectedClass;
    }

    public List<String> inferenceAll() {
        List<Long> allID = retriveAllDatasetID();
        List<String> conclusions = new ArrayList<String>();
        for (Long id : allID) {
            InitState(id);
            conclusions.add(id + ";" + Inference());
        }
        return conclusions;
    }

    private List<Long> retriveAllDatasetID() {
        List<Long> result = new ArrayList<Long>();
        for (CSVRecord csvRecord : csvRecords) {
            result.add(Long.valueOf(csvRecord.get(0)));
        }
        return result;
    }

}
