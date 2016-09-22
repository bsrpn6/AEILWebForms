using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class PartNumber : System.Web.UI.Page
{
    public string Error;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ResetForm();
        }

    }

    protected void SubmitButton_Click(object sender, EventArgs e)
    {
        ExecuteQuery(0);
    }

    public void ExecuteQuery(int Override)
    {
        //Create a connection to the SQL Server; modify the connection string for your environment.
        //SqlConnection MyConnection = new SqlConnection("server=(local);database=pubs;Trusted_Connection=yes");
        SqlConnection MyConnection = new SqlConnection("server=(local);database=AEIL_ANDON_MESEXT;UID=wwUser;PWD=wwUser;");

        //Create a DataAdapter, and then provide the name of the stored procedure.
        SqlDataAdapter MyDataAdapter = new SqlDataAdapter("iaLinePartNumberUpdate", MyConnection);

        //Set the command type as StoredProcedure.
        MyDataAdapter.SelectCommand.CommandType = CommandType.StoredProcedure;

        //Create and add a parameter to Parameters collection for the stored procedure.
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@Action", SqlDbType.VarChar, 8));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@OverRide", SqlDbType.Bit));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@LineTag", SqlDbType.VarChar, 20));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@ModelCode", SqlDbType.Int));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@PartNumber", SqlDbType.VarChar, 12));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@ModelName", SqlDbType.VarChar, 20));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@Product", SqlDbType.VarChar, 12));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@LineClass", SqlDbType.VarChar, 20));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@PartName", SqlDbType.VarChar, 50));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@CrewSetup", SqlDbType.VarChar, 20));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@CycleRate", SqlDbType.Real));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@PiecesPerSheet", SqlDbType.Int));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@PiecesPerKanBan", SqlDbType.Int));
        MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@OperatorCount", SqlDbType.Int));


        //Assign the search value to the parameter.
        MyDataAdapter.SelectCommand.Parameters["@Action"].Value = (ActionList.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@OverRide"].Value = Override;
        MyDataAdapter.SelectCommand.Parameters["@LineTag"].Value = (LineList.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@ModelCode"].Value =
            string.IsNullOrEmpty(ModelCodeTextBox.Text) ? 0 : Convert.ToInt32((ModelCodeTextBox.Text).Trim());
        MyDataAdapter.SelectCommand.Parameters["@PartNumber"].Value = (PartNumberTextBox.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@ModelName"].Value = ""; //(ModelNameTextBox.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@Product"].Value = (ProductTextBox.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@LineClass"].Value = (LineClassList.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@PartName"].Value = (PartNameTextBox.Text).Trim();
        MyDataAdapter.SelectCommand.Parameters["@CrewSetup"].Value = "";
        MyDataAdapter.SelectCommand.Parameters["@CycleRate"].Value =
            string.IsNullOrEmpty(CycleRateTextBox.Text) ? 0 : Convert.ToDecimal((CycleRateTextBox.Text).Trim());
        MyDataAdapter.SelectCommand.Parameters["@PiecesPerSheet"].Value = 0;
        //string.IsNullOrEmpty(PiecesPerSheetTextBox.Text) ? 0 : Convert.ToInt32((PiecesPerSheetTextBox.Text).Trim());
        MyDataAdapter.SelectCommand.Parameters["@PiecesPerKanBan"].Value = 0;
        //string.IsNullOrEmpty(PiecesPerKanbanTextBox.Text) ? 0 : Convert.ToInt32((PiecesPerKanbanTextBox.Text).Trim());
        MyDataAdapter.SelectCommand.Parameters["@OperatorCount"].Value =
            string.IsNullOrEmpty(OperatorCountTextBox.Text) ? 0 : Convert.ToInt32((OperatorCountTextBox.Text).Trim());

        var ErrorMessage = MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@ErrorMsg", SqlDbType.VarChar, 80));
        MyDataAdapter.SelectCommand.Parameters["@ErrorMsg"].Value = "";
        MyDataAdapter.SelectCommand.Parameters["@ErrorMsg"].Direction = ParameterDirection.InputOutput;



        var ReturnValue = MyDataAdapter.SelectCommand.Parameters.Add(new SqlParameter("@ReturnVal", SqlDbType.Int));
        ReturnValue.Direction = ParameterDirection.ReturnValue;

        MyConnection.Open();

        MyDataAdapter.SelectCommand.ExecuteNonQuery();

        MyDataAdapter.Dispose(); //Dispose the DataAdapter.
        MyConnection.Close(); //Close the connection.

        HandleStoredProcReturnValue(Convert.ToInt32(ReturnValue.Value), ErrorMessage.Value.ToString());

    }

    public void HandleStoredProcReturnValue(int ReturnValue, string ErrorMessage)
    {
        OverrideButton.Visible = false;
        Error = "";

        if (ReturnValue == 1)
        {
            // Gets the executing web page 
            Page page = HttpContext.Current.CurrentHandler as Page;

            string script = string.Format("alert('{0}');", "Success!");

            if (page != null && !page.ClientScript.IsClientScriptBlockRegistered("alert"))
            {
                page.ClientScript.RegisterClientScriptBlock(page.GetType(), "alert", script, true /* addScriptTags */);
            }
        }
        else
        {
            Error = ErrorMessage;

            if (ReturnValue == 99)
            {
                OverrideButton.Visible = true;
            }
        }
    }
    protected void ResetForm()
    {
        OverrideButton.Visible = false;

        Error = "";

        ActionList.SelectedIndex = 0;
        LineTagLabel.Enabled = false;
        LineList.Enabled = false;
        LineClassLabel.Enabled = false;
        LineClassList.Enabled = false;
        ModelCodeLabel.Enabled = false;
        ModelCodeTextBox.Enabled = false;
        ModelCodeTextBox.Text = "";
        PartNumberLabel.Enabled = false;
        PartNumberTextBox.Enabled = false;
        PartNumberTextBox.Text = "";
        //ModelNameLabel.Enabled = false;
        //ModelNameTextBox.Enabled = false;
        //ModelNameTextBox.Text = "";
        ProductLabel.Enabled = false;
        ProductTextBox.Enabled = false;
        ProductTextBox.Text = "";
        PartNameLabel.Enabled = false;
        PartNameTextBox.Enabled = false;
        PartNameTextBox.Text = "";
        CycleRateLabel.Enabled = false;
        CycleRateTextBox.Enabled = false;
        CycleRateTextBox.Text = "";
        OperatorCountLabel.Enabled = false;
        OperatorCountTextBox.Enabled = false;
        OperatorCountTextBox.Text = "";
        //PiecesPerSheetLabel.Enabled = false;
        //PiecesPerSheetTextBox.Enabled = false;
        //PiecesPerSheetTextBox.Text = "";
        //PiecesPerKanbanLabel.Enabled = false;
        //PiecesPerKanbanTextBox.Enabled = false;
        //PiecesPerKanbanTextBox.Text = "";
    }
    protected void ActionList_SelectedIndexChanged(object sender, EventArgs e)
    {
        Error = "";
        OverrideButton.Visible = false;
        switch (ActionList.Text)
        {
            case "MODCHNG":
                LineTagLabel.Enabled = true;
                LineList.Enabled = true;
                LineClassLabel.Enabled = false;
                LineClassList.Enabled = false;
                ModelCodeLabel.Enabled = true;
                ModelCodeTextBox.Enabled = true;
                PartNumberLabel.Enabled = true;
                PartNumberTextBox.Enabled = true;
                //ModelNameLabel.Enabled = false;
                //ModelNameTextBox.Enabled = false;
                ProductLabel.Enabled = false;
                ProductTextBox.Enabled = false;
                PartNameLabel.Enabled = false;
                PartNameTextBox.Enabled = false;
                CycleRateLabel.Enabled = true;
                CycleRateTextBox.Enabled = true;
                OperatorCountLabel.Enabled = true;
                OperatorCountTextBox.Enabled = true;
                //PiecesPerSheetLabel.Enabled = false;
                //PiecesPerSheetTextBox.Enabled = false;
                //PiecesPerKanbanLabel.Enabled = false;
                //PiecesPerKanbanTextBox.Enabled = false;
                break;

            case "PARTADD":
                LineTagLabel.Enabled = false;
                LineList.Enabled = false;
                LineClassLabel.Enabled = true;
                LineClassList.Enabled = true;
                ModelCodeLabel.Enabled = false;
                ModelCodeTextBox.Enabled = false;
                PartNumberLabel.Enabled = true;
                PartNumberTextBox.Enabled = true;
                //ModelNameLabel.Enabled = true;
                //ModelNameTextBox.Enabled = true;
                ProductLabel.Enabled = true;
                ProductTextBox.Enabled = true;
                PartNameLabel.Enabled = true;
                PartNameTextBox.Enabled = true;
                CycleRateLabel.Enabled = false;
                CycleRateTextBox.Enabled = false;
                OperatorCountLabel.Enabled = false;
                OperatorCountTextBox.Enabled = false;
                //PiecesPerSheetLabel.Enabled = true;
                //PiecesPerSheetTextBox.Enabled = true;
                //PiecesPerKanbanLabel.Enabled = true;
                //PiecesPerKanbanTextBox.Enabled = true;
                break;

            case "PARTDEL":
                LineTagLabel.Enabled = false;
                LineList.Enabled = false;
                LineClassLabel.Enabled = true;
                LineClassList.Enabled = true;
                ModelCodeLabel.Enabled = false;
                ModelCodeTextBox.Enabled = false;
                PartNumberLabel.Enabled = true;
                PartNumberTextBox.Enabled = true;
                //ModelNameLabel.Enabled = false;
                //ModelNameTextBox.Enabled = false;
                ProductLabel.Enabled = false;
                ProductTextBox.Enabled = false;
                PartNameLabel.Enabled = false;
                PartNameTextBox.Enabled = false;
                CycleRateLabel.Enabled = false;
                CycleRateTextBox.Enabled = false;
                OperatorCountLabel.Enabled = false;
                OperatorCountTextBox.Enabled = false;
                //PiecesPerSheetLabel.Enabled = false;
                //PiecesPerSheetTextBox.Enabled = false;
                //PiecesPerKanbanLabel.Enabled = false;
                //PiecesPerKanbanTextBox.Enabled = false;
                break;

            default:
                ResetForm();
                break;

        }
    }

    protected void ResetButton_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    protected void OverrideButton_Click(object sender, EventArgs e)
    {
        ExecuteQuery(1);
    }
}