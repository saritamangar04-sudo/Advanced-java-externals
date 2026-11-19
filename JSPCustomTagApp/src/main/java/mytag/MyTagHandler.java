package mytag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

public class MyTagHandler extends TagSupport
{
    private String page, action;

    public void setPage(String p) {
        page = p;
    }

    public void setAction(String a) {
        action = a;
    }

    public int doStartTag() throws JspException {
        try {
            if ("include".equalsIgnoreCase(action))
                pageContext.include(page);
            else if ("forward".equalsIgnoreCase(action))
                pageContext.forward(page);
            else
                pageContext.getOut().println("Invalid action");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return SKIP_BODY;
    }
}
