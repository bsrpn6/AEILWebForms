<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PartNumber.aspx.cs" Inherits="PartNumber" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Part & Model Change</title>
    <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div> 

    </div>
    <div id ="PartNumForm" class ="form">
        <form id="PartNumberForm" runat="server" class="Form">
        <p>
            This form is to be used for modifying cycle times and model code assignments. Adding and deleting of part numbers is also supported. To protect against changing/deleting data accidently,
            an override may be required, in which case an error message will be displayed and an Override button will appear.
        </p>
        <p>
            * All enabled fields are required for specified action.
        </p>
        <p>
            <asp:DropDownList CssClass="dropdown" ID="ActionList" runat="server" OnSelectedIndexChanged="ActionList_SelectedIndexChanged" AutoPostBack="True">
                <asp:ListItem></asp:ListItem>
                <asp:ListItem Value="MODCHNG">Model Change</asp:ListItem>
                <asp:ListItem Value="PARTADD">Part Add</asp:ListItem>
                <asp:ListItem Value="PARTDEL">Part Delete</asp:ListItem>
            </asp:DropDownList>
            <asp:Label CssClass ="label" ID="ActionLabel" runat="server" Text="ACTION"></asp:Label>
        </p>
        <p>
            <asp:DropDownList CssClass="dropdown" ID="LineList" runat="server" DataSourceID="SqlDataSource1" DataTextField="LineTag" DataValueField="LineTag">
            </asp:DropDownList>
            <asp:Label CssClass ="label" ID="LineTagLabel" runat="server" Text="Line Tag"></asp:Label>
        </p>
        <p>
            <asp:DropDownList CssClass="dropdown" ID="LineClassList" runat="server" DataSourceID="SqlDataSource2" DataTextField="LineClass" DataValueField="LineClass"></asp:DropDownList>
            <asp:Label CssClass ="label" ID="LineClassLabel" runat="server" Text="Line Class"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="ModelCodeTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="ModelCodeLabel" runat="server" Text="Model Code"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="PartNumberTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="PartNumberLabel" runat="server" Text="Part Number"></asp:Label>
        </p>
        <%--
        <p>
            <asp:TextBox CssClass = "textbox" ID="ModelNameTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="ModelNameLabel" runat="server" Text="Model Name"></asp:Label>
        </p>
         --%>
        <p>
            <asp:TextBox CssClass = "textbox" ID="ProductTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="ProductLabel" runat="server" Text="Product"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="PartNameTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="PartNameLabel" runat="server" Text="Part Name"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="CycleRateTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="CycleRateLabel" runat="server" Text="Cycle Rate"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="OperatorCountTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="OperatorCountLabel" runat="server" Text="Operator Count"></asp:Label>
        </p>
        <%--
        <p>
            <asp:TextBox CssClass = "textbox" ID="PiecesPerSheetTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="PiecesPerSheetLabel" runat="server" Text="Pieces Per Sheet"></asp:Label>
        </p>
        <p>
            <asp:TextBox CssClass = "textbox" ID="PiecesPerKanbanTextBox" runat="server"></asp:TextBox>
            <asp:Label CssClass ="label" ID="PiecesPerKanbanLabel" runat="server" Text="Pieces Per Kanban"></asp:Label>
        </p>
        --%>
        <p class ="errormessage">
            <%= Error %>
        </p>

        <asp:Button CssClass="button" ID="SubmitButton" runat="server" Text="Submit" OnClick="SubmitButton_Click" />
        <asp:Button CssClass="button" ID="ResetButton" runat="server" Text="Reset" OnClick="ResetButton_Click" />
        <asp:Button CssClass="overridebutton" ID="OverrideButton" runat="server" Text="Override" OnClick="OverrideButton_Click" />
        
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AEIL_ANDON_MESEXTConnectionString %>" SelectCommand="SELECT [LineTag] FROM [Lines]"></asp:SqlDataSource>
    
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:AEIL_ANDON_MESEXTConnectionString %>" SelectCommand="SELECT [LineClass] FROM [LineClass]"></asp:SqlDataSource>
    </form>
    </div>
</body>
</html>
