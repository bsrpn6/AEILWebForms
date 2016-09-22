USE [master]
GO
/****** Object:  Database [AEIL_ANDON_MESEXT]    Script Date: 9/22/2016 3:35:01 PM ******/
CREATE DATABASE [AEIL_ANDON_MESEXT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AEIL_ANDON_MESEXT', FILENAME = N'E:\MSSQL\DATA\AEIL_ANDON_MESEXT.mdf' , SIZE = 20480KB , MAXSIZE = UNLIMITED, FILEGROWTH = 5120KB )
 LOG ON 
( NAME = N'AEIL_ANDON_MESEXT_log', FILENAME = N'E:\MSSQL\DATA\AEIL_ANDON_MESEXT_log.ldf' , SIZE = 5120KB , MAXSIZE = 2048GB , FILEGROWTH = 5120KB )
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AEIL_ANDON_MESEXT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ARITHABORT OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET RECOVERY FULL 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET  MULTI_USER 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [AEIL_ANDON_MESEXT]
GO
/****** Object:  User [wwUser]    Script Date: 9/22/2016 3:35:01 PM ******/
CREATE USER [wwUser] FOR LOGIN [wwUser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IIS APPPOOL\ASP.NET v4.0]    Script Date: 9/22/2016 3:35:01 PM ******/
CREATE USER [IIS APPPOOL\ASP.NET v4.0] FOR LOGIN [IIS APPPOOL\ASP.NET v4.0] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [IIS APPPOOL\ASP.NET v4.0]
GO
/****** Object:  StoredProcedure [dbo].[iaCheckConnect]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: 02/10/2015
-- Description:	Inserts data into the MachineAlarmHist table and returns a 0/1 based off of the alarm state.
-- =============================================
CREATE PROCEDURE [dbo].[iaCheckConnect]
AS
BEGIN
	RETURN 0
END

GO
/****** Object:  StoredProcedure [dbo].[iaLinePartNumberUpdate]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Brandon Ray
-- Create date: 12/15/2015
-- Description:	Handles adding/updating/deleting 
-- of line part numbers, cycle times, and crew setups
-- =============================================
CREATE PROCEDURE [dbo].[iaLinePartNumberUpdate]
	@Action varchar(8),
	@OverRide bit,
	@LineTag varchar(20),
	@ModelCode int, 
	@PartNumber varchar(12),
	@ModelName varchar(20),
	@Product varchar(12),
	@LineClass varchar(20),
	@PartName varchar(50),
	@CrewSetup varchar(20),
	@CycleRate real,
	@PiecesPerSheet int,
	@PiecesPerKanBan int,
	@OperatorCount int,
	@ErrorMsg varchar(80) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
		@ReturnVal int,
		@Count int -- used for error checking

	SET @ReturnVal = 0
	SET @ErrorMsg = ''

	-- Handle changing of part for specified model code by line
	IF @Action = 'MODCHNG'
		BEGIN --Model code change

		/* Check to make sure valid inputs provided */
		IF @LineTag = '' OR @PartNumber = '' OR @ModelCode = 0 OR @CycleRate = 0 or @OperatorCount = 0
			BEGIN -- Invalid inputs
			Set @ErrorMsg = 'ERROR, Not all required parameters provided'
			GOTO LocalExit
			END -- Invalid inputs

		/* Get CrewSetup */
		SELECT
			@CrewSetup = lcs.CrewSetup
			FROM dbo.LineCrewSetups lcs
				WHERE lcs.LineTag = @LineTag
					AND lcs.OperatorCount = @OperatorCount
		
		IF @CrewSetup = ''
			BEGIN
			SET @ErrorMsg = 'ERROR, No CrewSetup defined'
			GOTO LocalExit
			END

		/* Check to see if part exists in PartNumber table */
		SELECT @Count = Count(pn.PartNumber)
			FROM dbo.Lines l
			INNER JOIN dbo.PartNumbers pn ON l.LineClass = pn.LineClass
			WHERE pn.PartNumber = @PartNumber
				AND l.LineTag = @LineTag

		IF @Count = 0
			BEGIN -- Part does not exist
			Set @ErrorMsg = 'ERROR, PartNumber does not exist for specified LineClass. Use PARTADD.'
			GOTO LocalExit
			END -- Part does not exist

		SELECT
			@Count = Count(ModelCode)
			FROM dbo.LinePartNumbers
			WHERE LineTag = @LineTag
				AND PartNumber = @PartNumber
				AND ModelCode = @ModelCode
				--AND CrewSetup = @CrewSetup

		IF @Count = 0
			BEGIN
			IF @Override = 1
				BEGIN
				DELETE FROM dbo.LinePartNumbers 
					WHERE LineTag = @LineTag
						AND ModelCode = @ModelCode
				END
			ELSE
				BEGIN
				SET @ErrorMsg = 'ERROR, PartNumber does not exist for ModelCode. Set Override = 1 to add.'
				SET @ReturnVal = 99
				GOTO LocalExit
				END
			END

		SELECT
			@Count = Count(ModelCode)
			FROM dbo.LinePartNumbers
			WHERE LineTag = @LineTag
				AND PartNumber = @PartNumber
				AND ModelCode = @ModelCode
				AND CrewSetup = @CrewSetup

		If @Count = 1
			BEGIN
			UPDATE dbo.LinePartNumbers SET
				DefaultCycle = @CycleRate
				WHERE LineTag = @LineTag AND PartNumber = @PartNumber AND ModelCode = @ModelCode AND @CrewSetup = CrewSetup
			SET @ReturnVal = 1
			GOTO LocalExit
			END

		/* Insert new record */
		INSERT dbo.LinePartNumbers
			(LineTag, PartNumber, CrewSetup, DefaultCycle, ModelCode, IsDefaultSetup)
			VALUES 
			(@LineTag, @PartNumber, @CrewSetup, @CycleRate, @ModelCode, 0)

		SET @ReturnVal = 1

		END -- Model code change

    -- Handle addition of a new part number
	IF @Action = 'PARTADD'
		BEGIN -- PartNumber add
		-- This action will add a new part number to the PartNumbers table

		/* Check to make sure valid inputs provided */
		IF @PartNumber = '' OR @Product = '' OR @LineClass = '' OR @PartName = ''
			BEGIN -- Invalid inputs
			SET @ErrorMsg = 'ERROR, Not all required parameters provided'
			GOTO LocalExit
			END -- Invalid inputs

		/* See if PartNumber already exists */
		SELECT 
			@Count = Count(PartNumber)
			FROM dbo.PartNumbers
			WHERE PartNumber = @PartNumber AND LineClass = @LineClass

		If @Count > 0
			BEGIN
			SET @ErrorMsg = 'ERROR, PartNumber already exists for this line class'
			GOTO LocalExit
			END

		/* Insert new part in PartNumbers table */
		INSERT dbo.PartNumbers
			(PartNumber, ModelName, Product, LineClass, ModelCode, PartName, PiecesPerSheet, PiecesPerKanban)
			VALUES
			(@PartNumber, @ModelName, @Product, @LineClass, 0, @PartName, @PiecesPerSheet, @PiecesPerKanBan)

		SET @ReturnVal = 1

		END -- PartNumber add

    -- Handle deletion of a part number
	IF @Action = 'PARTDEL'
		BEGIN -- PartNumber delete
		-- This action will delete a part from the part numbers table 
		-- First will check to make sure part doesn't exist in LinePartNumbers table, requires override to complete
		
		/* Check to make sure valid inputs provided */
		IF @PartNumber = '' OR @LineClass = ''
			BEGIN -- Invalid inputs
			SET @ErrorMsg = 'ERROR, Not all required parameters provided'
			GOTO LocalExit
			END -- Invalid inputs
			
		SELECT 
			@Count = Count(PartNumber)
			FROM dbo.LinePartNumbers lpn
			INNER JOIN dbo.Lines l ON l.LineTag = lpn.LineTag
			WHERE PartNumber = @PartNumber
				AND l.LineClass = @LineClass
		
		If @Count > 0
			BEGIN
			IF @OverRide = 1
				BEGIN
				/* Delete all records from LinePartNumbers table */
				DELETE FROM dbo.LinePartNumbers 
					WHERE PartNumber = @PartNumber
				END
			ELSE
				BEGIN
				SET @ErrorMsg = 'ERROR, PartNumber exists in LinePartNumbers table. Requires OverRide = 1.'
				SET @ReturnVal = 99
				GOTO LocalExit
				END
			END
			
		/* Delete all records from PartNumbers table */
		DELETE FROM dbo.PartNumbers
			WHERE PartNumber = @PartNumber AND LineClass = @LineClass
		
		SET @ReturnVal = 1
		
		END -- PartNumber delete

LocalExit:

	RETURN @ReturnVal
END


GO
/****** Object:  StoredProcedure [dbo].[iaLineSchedRuns]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marc Bertrand
-- Create date: 11/11/2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[iaLineSchedRuns]
	@LineTag varchar(20),
	@Action varchar(8),
	@ShiftNumber int,
	@ModelCode int, 
	@PartNumber varchar(12) OUTPUT,
	@PartName varchar(50) OUTPUT,
	@SchedDate varchar(20) OUTPUT,
	@CrewSetup varchar(20) OUTPUT,
	@LineSchedRunID int OUTPUT,
	@CycleRate real OUTPUT,
	@PiecesPerSheet int OUTPUT,
	@OperatorCount int OUTPUT,
	@PlanQty int OUTPUT,
	@ActualQty int OUTPUT,
	@ErrorMsg varchar(80) OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE
		@ReturnVal int

	SET @ReturnVal = 0
	SET @ErrorMsg = ''

    -- Handle Model Code Change Action
	IF @Action = 'MODCHG'
		BEGIN -- Model Code Change
		-- This Action Will Either Find or Create a Run Entry for the Model Code and Optionally Close Out the Previous Run
		-- This Action is Called By IAS When Line Starts up Or When Model Code Changes
		-- Required Inputs are LineTag, ShiftNumber, ModelCode
		-- Optional Inputs are CrewSetup, LineSchedRunID
		/* Check To Make Sure Valid */
		IF @ShiftNumber = 0 OR @ModelCode = 0
			BEGIN -- Invalid ModelCode
			SET @ErrorMsg = 'ERROR, Model Code and Shift Number Must Both Be Non-Zero'
			GOTO LocalExit
			END -- Invalid ModelCode
		IF @LineSchedRunID > 0
			BEGIN -- Update Plan/Actual
			-- Update Plan/Act for Last Run
			UPDATE dbo.LineSchedRuns SET
				PlanQty = @PlanQty,
				ActualQty = @ActualQty,
				RunStatus = 'Done',
				RunLastEnded = getdate()
				WHERE LineSchedRunID = @LineSchedRunID
			-- Set Default Return Value
			SET @LineSchedRunID = 0
			END -- Update Plan/Actual
		/* If CrewSetup Not Specified, Get Default */
		IF @CrewSetup = ''
			BEGIN -- Default Crew Setup
			SELECT TOP 1
				@CrewSetup = lpn.CrewSetup
				FROM dbo.LinePartNumbers lpn
				WHERE lpn.LineTag = @LineTag
				  AND lpn.ModelCode = @ModelCode
				ORDER BY IsDefaultSetup DESC
			END -- Default Crew Setup
		/* Get PartNumber, Cycle From LinePartNumbers */
		SET @PartNumber = ''
		SELECT
			@PartNumber = pn.PartNumber,
			@PartName = pn.PartName,
			@CycleRate = lpn.DefaultCycle,
			@SchedDate = CONVERT(varchar(20), getdate(), 1),
			@OperatorCount = lcs.OperatorCount,
			@PiecesPerSheet = pn.PiecesPerSheet
			FROM dbo.LinePartNumbers lpn
			INNER JOIN dbo.PartNumbers pn ON lpn.PartNumber = pn.PartNumber
			INNER JOIN dbo.LineCrewSetups lcs ON lpn.LineTag = lcs.LineTag AND lpn.CrewSetup = lcs.CrewSetup
			WHERE lpn.LineTag = @LineTag
			  AND lpn.ModelCode = @ModelCode
			  AND lpn.CrewSetup = @CrewSetup
		/* Check To Make Sure Valid */
		IF @PartNumber = ''
			BEGIN -- Invalid ModelCode
			SET @ErrorMsg = 'ERROR, Invalid ModelCode or Crew Setup Specified'
			GOTO LocalExit
			END -- Invalid ModelCode
		/* Find Run Entry */
		SELECT
			@LineSchedRunID = LineSchedRunID,
			@PlanQty = PlanQty,
			@ActualQty = ActualQty
			FROM dbo.LineSchedRuns
			WHERE LineTag = @LineTag
			  AND SchedDate = @SchedDate
			  AND ShiftNumber = @ShiftNumber
			  AND CrewSetup = @CrewSetup
		IF @LineSchedRunID = 0
			BEGIN -- Create New Run Entry
			SElECT @PlanQty = 0, @ActualQty = 0
			INSERT dbo.LineSchedRuns
				(LineTag, SchedDate, ShiftNumber, PartNumber, CrewSetup, CycleRate, OperatorCount, PlanQty, ActualQty, RunStatus, RunFirstStarted)
				VALUES
				(@LineTag, @SchedDate, @ShiftNumber, @PartNumber, @CrewSetup, @CycleRate, @OperatorCount, @PlanQty, @ActualQty, 'Active', getdate())
			SET @LineSchedRunID = @@IDENTITY
			END -- Create New Run Entry
		END -- Model Code Change

    -- Handle Shift Code Change Action
	IF @Action = 'SHIFTCHG'
		BEGIN -- Shift Number Change
		-- This Action Will Split An Existing Run to a New Shift
		-- Required Inputs are LineTag, ShiftNumber, LineSchedRunID
		IF @LineSchedRunID = 0
			BEGIN -- Invalid LineSchedRunID
			SET @ErrorMsg = 'ERROR in SHIFTCHG, Invalid LineSchedRunID'
			GOTO LocalExit
			END -- Invalid LineSchedRunID
		-- Update Plan/Act for Last Run
		UPDATE dbo.LineSchedRuns SET
			PlanQty = @PlanQty,
			ActualQty = @ActualQty,
			RunStatus = 'Done',
			RunLastEnded = getdate()
			WHERE LineSchedRunID = @LineSchedRunID
		SET @SchedDate = CONVERT(varchar(20), getdate(), 1)
		IF @PlanQty > @ActualQty
			SET @PlanQty = @PlanQty - @ActualQty
		INSERT dbo.LineSchedRuns
			(LineTag, SchedDate, ShiftNumber, PartNumber, CrewSetup, CycleRate, OperatorCount, PlanQty, ActualQty, RunStatus, RunFirstStarted)
			SELECT
			@LineTag, @SchedDate, @ShiftNumber, PartNumber, CrewSetup, CycleRate, OperatorCount, @PlanQty, 0, 'Active', getdate()
			FROM dbo.LineSchedRuns
			WHERE LineSchedRunID = @LineSchedRunID
		SET @LineSchedRunID = @@IDENTITY
		END -- Shift Number Change

    -- Handle Run Update/Run End Methods
	IF (@Action = 'RUNEND') OR (@Action = 'RUNUPD')
		BEGIN -- Run Update/Run End Methods
		-- This Action Will Split An Existing Run to a New Shift
		-- Required Inputs are LineTag, LineSchedRunID
		IF @LineSchedRunID = 0
			BEGIN -- Invalid LineSchedRunID
			SET @ErrorMsg = 'ERROR in SHIFTCHG, Invalid LineSchedRunID'
			GOTO LocalExit
			END -- Invalid LineSchedRunID
		-- Update Plan/Act for Last Run
		UPDATE dbo.LineSchedRuns SET
			PlanQty = @PlanQty,
			ActualQty = @ActualQty,
			RunStatus = CASE @Action WHEN 'RUNEND' THEN 'Done' ELSE RunStatus END,
			RunLastEnded = CASE @Action WHEN 'RUNEND' THEN getdate() ELSE NULL END
			WHERE LineSchedRunID = @LineSchedRunID
		IF @Action = 'RUNEND'
			SET @LineSchedRunID = @@IDENTITY
		END -- Run Update/Run End Methods

LocalExit:

	RETURN @ReturnVal
END


GO
/****** Object:  StoredProcedure [dbo].[iAMachineAlarm]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: 02/10/2015
-- Description:	Inserts data into the MachineAlarmHist table and returns a 0/1 based off of the alarm state.
-- =============================================
CREATE PROCEDURE [dbo].[iAMachineAlarm]
	-- Paramaters passed into stored procedure.
	@MachineTag varchar(16), 
	@AlarmId int, 
	@AlarmText varchar(100),
	@AlarmState int,
	@AlarmInstanceID int

AS

BEGIN

DECLARE @Return int

	IF @AlarmInstanceID = 0 
		BEGIN -- New Alarm
		-- Insert into table MachineAlarmHist
		INSERT INTO dbo.MachineAlarmHist ([MachineTag], [AlarmID], [AlarmText], [AlarmOnDate])
		VALUES (@MachineTag, @AlarmID, @AlarmText, GETDATE())
		SET @Return = @@IDENTITY
		END -- New Alarm
	ELSE
		BEGIN -- Update Alarm
		UPDATE dbo.MachineAlarmHist SET AlarmOffDate = GETDATE() WHERE AlarmInstanceID = @AlarmInstanceID
		SET @Return = 0
		END -- Update Alarm

	RETURN @Return
END

GO
/****** Object:  StoredProcedure [dbo].[iaMachineStateChange]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Brent Powers
-- Create date: 2/16/2015
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[iaMachineStateChange]
	-- Add the parameters for the stored procedure here
	@MachineTag varchar(20),
	@State nvarchar(4),
	@Reason varchar(200)
AS
BEGIN
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	DECLARE @Open_State AS NVARCHAR(4)

	SET @Open_State = (SELECT State_CD FROM [dbo].[MachineUtil] WHERE MachineTag = @MachineTag AND (EndTime IS NULL) AND (Duration IS NULL))

	--IF Machine has changed state from open state in table (Prevent extra entries from Redeploy of object) AND not empty string
	IF ((@State <> @Open_State) OR @Open_State IS NULL) AND (@State <> '')
	BEGIN
		-- Close any open events for machine. Set EndTime and calculation Duration
		UPDATE [dbo].[MachineUtil]
		SET EndTime = GETDATE(), Duration = (DATEDIFF(second, StartTime, GETDATE())/60.0)
		WHERE MachineTag = @MachineTag AND (EndTime IS NULL) AND (Duration IS NULL)

		--Insert base row for new event
		INSERT INTO [dbo].[MachineUtil] ([MachineTag] ,[State_CD] ,[Reason] ,[StartTime])
		VALUES (@MachineTag, @State, @Reason, GETDATE())
	END
	RETURN 0
END

GO
/****** Object:  Table [dbo].[LineClass]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LineClass](
	[LineClass] [varchar](20) NOT NULL,
	[LineClassDesc] [varchar](200) NOT NULL,
 CONSTRAINT [PK_LineClass] PRIMARY KEY CLUSTERED 
(
	[LineClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LineCrewSetups]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LineCrewSetups](
	[LineTag] [varchar](20) NOT NULL,
	[CrewSetup] [varchar](20) NOT NULL,
	[OperatorCount] [int] NOT NULL,
	[DefaultCycle] [real] NOT NULL CONSTRAINT [DF_LineCrewSetups_DefaultCycle]  DEFAULT ((0)),
	[IsDefaultSetup] [bit] NOT NULL DEFAULT ((1)),
 CONSTRAINT [PK_LineCrewSetups] PRIMARY KEY CLUSTERED 
(
	[LineTag] ASC,
	[CrewSetup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LinePartNumber_Import]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LinePartNumber_Import](
	[LineTag] [varchar](20) NOT NULL,
	[PartNumber] [varchar](12) NOT NULL,
	[ModelName] [varchar](100) NOT NULL,
	[Product] [varchar](12) NOT NULL,
	[DefaultCycle] [real] NOT NULL,
	[CT6OP] [real] NULL,
	[CT5OP] [real] NULL,
	[CT4OP] [real] NULL,
	[CT3OP] [real] NULL,
	[ModelCode] [int] NOT NULL,
	[PiecesPerSheet] [int] NOT NULL,
	[PiecesPerKanBan] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LinePartNumbers]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LinePartNumbers](
	[LineTag] [varchar](20) NOT NULL,
	[PartNumber] [varchar](12) NOT NULL,
	[CrewSetup] [varchar](20) NOT NULL,
	[DefaultCycle] [real] NOT NULL,
	[ModelCode] [int] NOT NULL,
	[IsDefaultSetup] [bit] NOT NULL DEFAULT ((1)),
 CONSTRAINT [PK_LinePartNumbers] PRIMARY KEY CLUSTERED 
(
	[LineTag] ASC,
	[PartNumber] ASC,
	[CrewSetup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lines]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Lines](
	[LineTag] [varchar](20) NOT NULL,
	[LineClass] [varchar](20) NOT NULL,
	[LineDesc] [varchar](200) NULL,
 CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED 
(
	[LineTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LineSchedRuns]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LineSchedRuns](
	[LineTag] [varchar](20) NOT NULL,
	[SchedDate] [smalldatetime] NOT NULL,
	[ShiftNumber] [int] NOT NULL,
	[PartNumber] [varchar](12) NOT NULL,
	[CrewSetup] [varchar](20) NOT NULL,
	[LineSchedRunID] [int] IDENTITY(100000,1) NOT NULL,
	[CycleRate] [real] NOT NULL,
	[OperatorCount] [int] NOT NULL,
	[PlanQty] [int] NOT NULL,
	[ActualQty] [int] NOT NULL,
	[RunStatus] [varchar](12) NOT NULL,
	[RunFirstStarted] [datetime] NULL,
	[RunLastEnded] [datetime] NULL,
 CONSTRAINT [PK_LineSchedRuns] PRIMARY KEY CLUSTERED 
(
	[LineTag] ASC,
	[SchedDate] ASC,
	[ShiftNumber] ASC,
	[PartNumber] ASC,
	[CrewSetup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MachineAlarmHist]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MachineAlarmHist](
	[AlarmInstanceID] [int] IDENTITY(100000,1) NOT NULL,
	[MachineTag] [varchar](16) NULL,
	[AlarmID] [int] NULL,
	[AlarmText] [varchar](100) NULL,
	[AlarmOnDate] [datetime] NULL,
	[AlarmOffDate] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MachineClass]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MachineClass](
	[MachineClass] [varchar](20) NOT NULL,
	[LineClass] [varchar](20) NOT NULL,
	[MachineClassDesc] [varchar](200) NULL,
 CONSTRAINT [PK_MachineClass] PRIMARY KEY CLUSTERED 
(
	[MachineClass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MachineClassAlarms]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MachineClassAlarms](
	[AlarmID] [int] IDENTITY(100000,1) NOT NULL,
	[MachineClass] [varchar](20) NULL,
	[PLCReg] [nchar](10) NULL,
	[AlarmText] [varchar](200) NULL,
	[AlarmDesc] [varchar](200) NULL,
	[AlarmSeverity] [int] NULL,
	[AlarmPriority] [int] NULL,
	[AlarmReadBlock] [int] NULL,
	[AlarmReadIndex] [int] NULL,
 CONSTRAINT [PK_MachineClassAlarms] PRIMARY KEY CLUSTERED 
(
	[AlarmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Machines]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Machines](
	[MachineTag] [varchar](20) NOT NULL,
	[Line] [varchar](20) NULL,
	[MachineDesc] [varchar](200) NULL,
	[MachineClass] [varchar](20) NULL,
 CONSTRAINT [PK_Machines] PRIMARY KEY CLUSTERED 
(
	[MachineTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MachineUtil]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MachineUtil](
	[EventID] [int] IDENTITY(100001,1) NOT NULL,
	[MachineTag] [varchar](20) NOT NULL,
	[State_CD] [nvarchar](4) NOT NULL,
	[Reason] [varchar](200) NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Duration] [real] NULL,
 CONSTRAINT [PK_EventID] PRIMARY KEY CLUSTERED 
(
	[EventID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PartNumbers]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PartNumbers](
	[PartNumber] [varchar](12) NOT NULL,
	[ModelName] [varchar](20) NOT NULL,
	[Product] [varchar](12) NOT NULL,
	[LineClass] [varchar](20) NOT NULL,
	[ModelCode] [int] NOT NULL,
	[PartName] [varchar](50) NULL,
	[PiecesPerSheet] [int] NOT NULL,
	[PiecesPerKanban] [int] NOT NULL,
 CONSTRAINT [PK_PartNumbers] PRIMARY KEY CLUSTERED 
(
	[PartNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[MachineAlarms]    Script Date: 9/22/2016 3:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[MachineAlarms]
AS
SELECT TOP 1000   dbo.Machines.MachineTag, dbo.MachineClassAlarms.AlarmText, dbo.MachineClassAlarms.AlarmSeverity, dbo.MachineClassAlarms.AlarmPriority, dbo.MachineClassAlarms.AlarmReadBlock, dbo.MachineClassAlarms.AlarmReadIndex
FROM         dbo.MachineClassAlarms 
INNER JOIN   dbo.Machines ON dbo.Machines.MachineClass = dbo.MachineClassAlarms.MachineClass
ORDER BY dbo.MachineClassAlarms.AlarmSeverity ASC, dbo.MachineClassAlarms.AlarmPriority ASC



GO
/****** Object:  Index [IX1_LineSchedRuns_ID]    Script Date: 9/22/2016 3:35:01 PM ******/
CREATE NONCLUSTERED INDEX [IX1_LineSchedRuns_ID] ON [dbo].[LineSchedRuns]
(
	[LineSchedRunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LineSchedRuns] ADD  CONSTRAINT [DF_LineSchedRuns_PlanQty]  DEFAULT ((0)) FOR [PlanQty]
GO
ALTER TABLE [dbo].[LineSchedRuns] ADD  CONSTRAINT [DF_LineSchedRuns_ActualQty]  DEFAULT ((0)) FOR [ActualQty]
GO
ALTER TABLE [dbo].[LineCrewSetups]  WITH CHECK ADD  CONSTRAINT [FK_LineCrewSetups_Lines] FOREIGN KEY([LineTag])
REFERENCES [dbo].[Lines] ([LineTag])
GO
ALTER TABLE [dbo].[LineCrewSetups] CHECK CONSTRAINT [FK_LineCrewSetups_Lines]
GO
ALTER TABLE [dbo].[LinePartNumbers]  WITH CHECK ADD  CONSTRAINT [FK_LinePartNumbers_LineCrewSetups] FOREIGN KEY([LineTag], [CrewSetup])
REFERENCES [dbo].[LineCrewSetups] ([LineTag], [CrewSetup])
GO
ALTER TABLE [dbo].[LinePartNumbers] CHECK CONSTRAINT [FK_LinePartNumbers_LineCrewSetups]
GO
ALTER TABLE [dbo].[LinePartNumbers]  WITH CHECK ADD  CONSTRAINT [FK_LinePartNumbers_PartNumbers] FOREIGN KEY([PartNumber])
REFERENCES [dbo].[PartNumbers] ([PartNumber])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LinePartNumbers] CHECK CONSTRAINT [FK_LinePartNumbers_PartNumbers]
GO
ALTER TABLE [dbo].[Lines]  WITH CHECK ADD  CONSTRAINT [FK_Lines_LineClass] FOREIGN KEY([LineClass])
REFERENCES [dbo].[LineClass] ([LineClass])
GO
ALTER TABLE [dbo].[Lines] CHECK CONSTRAINT [FK_Lines_LineClass]
GO
ALTER TABLE [dbo].[MachineClass]  WITH CHECK ADD  CONSTRAINT [FK_MachineClass_LineClass] FOREIGN KEY([LineClass])
REFERENCES [dbo].[LineClass] ([LineClass])
GO
ALTER TABLE [dbo].[MachineClass] CHECK CONSTRAINT [FK_MachineClass_LineClass]
GO
ALTER TABLE [dbo].[MachineClassAlarms]  WITH CHECK ADD  CONSTRAINT [FK_MachineClassAlarms_MachineClass] FOREIGN KEY([MachineClass])
REFERENCES [dbo].[MachineClass] ([MachineClass])
GO
ALTER TABLE [dbo].[MachineClassAlarms] CHECK CONSTRAINT [FK_MachineClassAlarms_MachineClass]
GO
ALTER TABLE [dbo].[Machines]  WITH CHECK ADD  CONSTRAINT [FK_Machines_Lines] FOREIGN KEY([Line])
REFERENCES [dbo].[Lines] ([LineTag])
GO
ALTER TABLE [dbo].[Machines] CHECK CONSTRAINT [FK_Machines_Lines]
GO
ALTER TABLE [dbo].[Machines]  WITH CHECK ADD  CONSTRAINT [FK_Machines_MachineClass] FOREIGN KEY([MachineClass])
REFERENCES [dbo].[MachineClass] ([MachineClass])
GO
ALTER TABLE [dbo].[Machines] CHECK CONSTRAINT [FK_Machines_MachineClass]
GO
ALTER TABLE [dbo].[MachineUtil]  WITH CHECK ADD  CONSTRAINT [FK_MachineUtil_Machines] FOREIGN KEY([MachineTag])
REFERENCES [dbo].[Machines] ([MachineTag])
GO
ALTER TABLE [dbo].[MachineUtil] CHECK CONSTRAINT [FK_MachineUtil_Machines]
GO
ALTER TABLE [dbo].[PartNumbers]  WITH CHECK ADD  CONSTRAINT [FK_PartNumbers_LineClass] FOREIGN KEY([LineClass])
REFERENCES [dbo].[LineClass] ([LineClass])
GO
ALTER TABLE [dbo].[PartNumbers] CHECK CONSTRAINT [FK_PartNumbers_LineClass]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MachineClassAlarms"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Machines"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 114
               Right = 387
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MachineAlarms'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MachineAlarms'
GO
USE [master]
GO
ALTER DATABASE [AEIL_ANDON_MESEXT] SET  READ_WRITE 
GO
