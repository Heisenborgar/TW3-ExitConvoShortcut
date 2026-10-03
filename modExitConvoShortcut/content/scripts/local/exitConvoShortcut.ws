@addField(CR4Player)
var exitConvoBHeld : bool;

@addMethod(CR4HudModuleDialog)
function FindExitChoice() : int
{
	var i : int;

	for( i = 0; i < lastSetChoices.Size(); i += 1 )
	{
		if( lastSetChoices[i].dialogAction == DialogAction_EXIT && !lastSetChoices[i].disabled )
		{
			return i;
		}
	}

	return -1;
}

@addMethod(CR4HudModuleDialog)
function TryExitDialog()
{
	var idx : int;

	idx = FindExitChoice();
	if( idx < 0 )
	{
		return;
	}

	OnDialogOptionSelected( idx );
	OnDialogOptionAccepted( idx );
}

@wrapMethod(CR4HudModuleDialog)
function OnDialogChoicesSet( choices : array< SSceneChoice >, alternativeUI : bool )
{
	wrappedMethod( choices, alternativeUI );

	if( choices.Size() > 0 )
	{
		thePlayer.AddTimer( 'PollExitConvoInput', 0.01, true );
	}
	else
	{
		thePlayer.RemoveTimer( 'PollExitConvoInput' );
	}
}

@addMethod(CR4Player)
timer function PollExitConvoInput( dt : float, id : int )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleDialog;

	if( !theInput.IsActionPressed( 'CloseRadialMenu' ) )
	{
		exitConvoBHeld = false;
		return;
	}

	if( exitConvoBHeld )
	{
		return;
	}

	exitConvoBHeld = true;

	hud = (CR4ScriptedHud)theGame.GetHud();
	module = (CR4HudModuleDialog)hud.GetHudModule( "DialogModule" );
	if( module )
	{
		module.TryExitDialog();
	}
}
