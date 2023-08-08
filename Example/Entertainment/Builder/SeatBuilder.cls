/*
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>
*/
/*------------------------------------------------------------------------
    File        : SeatBuilder
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk. Ltd.
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Entertainment.Builder.* from propath.
using Example.Entertainment.* from propath.

class Example.Entertainment.Builder.SeatBuilder
    inherits OpenEdge.Core.Util.ConfigBuilder
    abstract:

    define protected property ScreenCount as integer no-undo
    get.
    set.

    define public property Seat as ISeat no-undo
    get():
        return this-object:GetInstance().
    end get.

    method static public SeatBuilder Build(pcTravelClass as character):
        case pcTravelClass:
            when "super-lux" then .
            when "first" then .
            when "economy-001" then
                return (new DefaultSeatBuilder())
                            :AddScreen(1280, 1024)
                            :SetScreenResolution(ResolutionEnum:HighDefinition)
                            :SupportsTouch(yes)
                            :SupportsPictureInPicture(yes)
                            :EnableBluetooth(no)
                            :ControllerModel("C250").

            otherwise
                return new DefaultSeatBuilder().
        end case.
    end method.

    method static public SeatBuilder Build():
        return SeatBuilder:Build("").
    end method.

    method public SeatBuilder EnableBluetooth(plEnable as logical):
        this-object:SetOption("bluetooth", plEnable).

        return this-object.
    end method.

    method public SeatBuilder AddScreen(piHeight as integer, piWidth as integer):
        ScreenCount = ScreenCount + 1.

        this-object:SetOption("screenHeight-" + string(ScreenCount), piHeight).
        this-object:SetOption("screenWidth-" + string(ScreenCount), piWidth).

        return this-object.
    end method.

    method public SeatBuilder SetScreenResolution(poResolution as ResolutionEnum):
        this-object:SetOption("screenResolution-" + string(ScreenCount), poResolution).

        return this-object.
    end method.

    method public SeatBuilder SupportsPictureInPicture(plPip as logical):
        this-object:SetOption("screenPiP-" + string(ScreenCount), plPip).

        return this-object.
    end method.

    method public SeatBuilder SupportsTouch(plTouch as logical):
        this-object:SetOption("screenTouch-" + string(ScreenCount), plTouch).

        return this-object.
    end method.

    method public SeatBuilder SupportsCast(plcast as logical):
        this-object:SetOption("cast", plCast).

        return this-object.
    end method.

    method public SeatBuilder ControllerModel(pcController as character):
        this-object:SetOption("controller", pcController).

        return this-object.
    end method.

    method abstract protected ISeat GetInstance().

end class.

/*
Interface ISeat
    Property BluetoothEnabled as logical
    method void SelectOutputDevice(DeviceTypeEnum, <parameters>)
    method void PlayChannel(ChannelTypeEnum, pcId)

Interface ISeatScreen
    Property Height as integer
    Property Width as integer
    Property Resolution  as ResolutionEnum
    Property SupportsPictureInPicture as logical
    Property SupportsTouch as logical

Interface ISeatControls
    Property Controller as ControllerModel
    Method void InputCommand(<parameters>)

Interface ISeatCast
method void ConnectHost(<parameters>)
*/