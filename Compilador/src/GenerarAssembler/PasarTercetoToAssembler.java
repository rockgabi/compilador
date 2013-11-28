/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package GenerarAssembler;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;
import lexico.TablaSimbolos;
import cod_intermedio.Terceto;
/**
 *
 * @author damian
 */
public class PasarTercetoToAssembler {
    
    public Vector<String> traducir(Vector<Terceto> tercs, TablaSimbolos ts){

        SeguidorEstReg ser = new SeguidorEstReg(ts);
        Vector<String> asm = new Vector<String>();
        Hashtable<String, String> Messages = new Hashtable<String, String>();
        Hashtable<String, String> Codigo = new Hashtable<String, String>();

        // Genera el assembler por cada terceto, y agrega mensajes de error
        for(Terceto t: tercs){
            asm.addAll(t.generarAssembler(ser));
            if (t.throwsError()){
                String etiqueta = t.getEtiqueta();
                if (!Messages.containsKey(etiqueta)){
                    Messages.put(etiqueta, t.getMessageData());
                    Codigo.put(etiqueta, t.getErrorCode());
                }
            }
        }

        // Obtener todas las variables generadas
        Vector<String> variables = ser.getVariables();
        // Codigo de cabecera para las variables
        variables.insertElementAt(".386",0);
        variables.insertElementAt(".model flat, stdcall",1);
        variables.insertElementAt("option casemap :none",2);
        variables.insertElementAt("include \\masm32\\include\\windows.inc", 3);
        variables.insertElementAt("include \\masm32\\include\\kernel32.inc", 4);
        variables.insertElementAt("include \\masm32\\include\\user32.inc", 5);
        variables.insertElementAt("include \\masm32\\include\\masm32.inc", 6);
        variables.insertElementAt("includelib \\masm32\\lib\\kernel32.lib", 7);
        variables.insertElementAt("includelib \\masm32\\lib\\user32.lib", 8);
        variables.insertElementAt("includelib \\masm32\\lib\\user32.lib", 9);
        variables.insertElementAt(".DATA",10);
        
        Collection<String> e = Messages.values();
        for (Iterator<String> it = e.iterator(); it.hasNext();) {
            String string = it.next();
            variables.add(string);
        }
        variables.add(".CODE");
        Enumeration<String> ec = Codigo.keys();
        while (ec.hasMoreElements()) {
            String etiq = (String) ec.nextElement();
            variables.add(etiq+":");
            variables.add(Codigo.get(etiq));
        }
        variables.add("SALIR:");
        variables.add("invoke ExitProcess,0			; DOS: termina el programa");
        variables.add("START:");
        //variables.add("MOV ax,@DATA ;obtener la posicion de los datos");
        //variables.add("MOV ds,ax ; cargar el segmento de datos con el puntero");

        variables.addAll(asm);
        variables.add("JMP SALIR");
        variables.add("END START");
        return variables;
    }

}