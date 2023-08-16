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
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.* from propath.

class Example.Entertainment.Builder.SeatBuilder
    inherits OpenEdge.Core.Util.ConfigBuilder
    implements ISeatBuilder
    abstract:

    define static protected property oConfig as JsonObject no-undo
    get.
    private set.

    define protected property TravelClass as character no-undo
    get.
    set.

    define public property Seat as ISeat no-undo
    get():
        return this-object:GetInstance().
    end get.

    constructor static SeatBuilder ():
        oConfig = cast((new ObjectModelParser()):ParseFile("config.json"), JsonObject).
    end constructor.

    constructor public SeatBuilder (pcTravelClass as character):
        this-object:TravelClass = pcTravelClass.
    end constructor.

    method static public ISeatBuilder Build (pcTravelClass as character):
        define variable cSeatBuilderType as character no-undo.
        define variable oSeatBuilder as ISeatBuilder no-undo.
        define variable oJson as JsonObject no-undo.

        if pcTravelClass > "" and oConfig:Has(pcTravelClass) and oConfig:GetType(pcTravelClass) = JsonDataType:OBJECT then do:
            oJson = oConfig:GetJsonObject(pcTravelClass).
            cSeatBuilderType = oJson:GetCharacter("builder").
        end.
        else
            cSeatBuilderType = get-class(DefaultSeatBuilder):TypeName.

        oSeatBuilder = dynamic-new cSeatBuilderType (pcTravelClass).

        return oSeatBuilder.

    end method.

    method static public ISeatBuilder Build ():
        return SeatBuilder:Build("").
    end method.

    method public ISeatBuilder EnableBluetooth (plEnable as logical):
        this-object:SetOption("bluetooth", plEnable).

        return this-object.
    end method.

    method public ISeatBuilder AddScreen(poScreen as Screen):
        this-object:SetOption("screen", poScreen).

        return this-object.
    end method.

    method public ISeatBuilder AddScreen (piHeight as integer, piWidth as integer):
        this-object:SetOption("screenHeight", piHeight).
        this-object:SetOption("screenWidth", piWidth).

        return this-object.
    end method.

    method public ISeatBuilder SetScreenResolution (poResolution as ResolutionEnum):
        this-object:SetOption("screenResolution", poResolution).

        return this-object.
    end method.

    method public ISeatBuilder SupportsPictureInPicture (plPip as logical):
        this-object:SetOption("screenPiP", plPip).

        return this-object.
    end method.

    method public ISeatBuilder SupportsTouch (plTouch as logical):
        this-object:SetOption("screenTouch", plTouch).

        return this-object.
    end method.

    method public ISeatBuilder SupportsCast (plcast as logical):
        this-object:SetOption("cast", plCast).

        return this-object.
    end method.

    method public ISeatBuilder ControllerModel (pcController as character):
        this-object:SetOption("controller", pcController).

        return this-object.
    end method.

    method abstract protected ISeat GetInstance ().

end class.
