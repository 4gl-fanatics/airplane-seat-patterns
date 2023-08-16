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
    File        : LuxurySeatBuilder
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

class Example.Entertainment.Builder.LuxurySeatBuilder
    inherits DefaultSeatBuilder:

    define variable iScreenCount as integer no-undo.

    constructor public LuxurySeatBuilder (pcTravelClass as character):
        super(pcTravelClass).
    end constructor.

    method override public ISeatBuilder AddScreen(poScreen as Screen):
        iScreenCount = iScreenCount + 1.

        this-object:SetOption("screen-" + string(iScreenCount), poScreen).

        return this-object.
    end method.

    method override public ISeatBuilder AddScreen (piHeight as integer, piWidth as integer):
        iScreenCount = iScreenCount + 1.

        this-object:SetOption("screenHeight-" + string(iScreenCount), piHeight).
        this-object:SetOption("screenWidth-" + string(iScreenCount), piWidth).

        return this-object.
    end method.

    method override public ISeatBuilder SetScreenResolution (poResolution as ResolutionEnum):
        this-object:SetOption("screenResolution-" + string(iScreenCount), poResolution).

        return this-object.
    end method.

    method override public ISeatBuilder SupportsPictureInPicture (plPip as logical):
        this-object:SetOption("screenPiP-" + string(iScreenCount), plPip).

        return this-object.
    end method.

    method override public ISeatBuilder SupportsTouch (plTouch as logical):
        this-object:SetOption("screenTouch-" + string(iScreenCount), plTouch).

        return this-object.
    end method.

    method override protected ISeat GetInstance():
        define variable oSeat as ISeat no-undo.
        define variable iLoop as integer no-undo.
        define variable oScreens as ISeatScreen no-undo extent.

        /* all the other things */
        oSeat = super:GetInstance().

        /* Screens */
        extent(oScreens) = iScreenCount.
        do iLoop = 1 to iScreenCount:
            if this-object:HasOption("screen-" + string(iLoop)) then
                oScreens[iLoop] = cast(this-object:GetOptionObjectValue("screen-" + string(iLoop)), Screen).
            else
                oScreens[iLoop] = new Screen(integer(this-object:GetOptionNumericValue("screenHeight-" + string(iLoop))),
                                    integer(this-object:GetOptionNumericValue("screenWidth-" + string(iLoop))),
                                    cast(this-object:GetOptionObjectValue("screenResolution-" + string(iLoop)), ResolutionEnum),
                                    this-object:GetOptionLogicalValue("screenPip-" + string(iLoop)),
                                    this-object:GetOptionLogicalValue("screenTouch-" + string(iLoop))).
        end.

        oSeat = new SeatMultiScreen(oScreens, oSeat).

        return oSeat.
    end method.

end class.
