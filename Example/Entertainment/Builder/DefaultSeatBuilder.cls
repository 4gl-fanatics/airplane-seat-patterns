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

class Example.Entertainment.Builder.DefaultSeatBuilder
    inherits SeatBuilder:

    constructor public DefaultSeatBuilder (pcTravelClass as character):
        super(pcTravelClass).
    end constructor.

    method override protected ISeat GetInstance():
        define variable oSeat as ISeat no-undo.

        oSeat = new Seat( this-object:GetOptionLogicalValue("bluetooth")).

        /* Screens? */
        if this-object:HasOption("screen") then
            oScreens[iLoop] = cast(this-object:GetOptionObjectValue("screen-" + string(iLoop)), Screen).
        else
        if this-object:HasOption("screenHeight") then
            oSeat = new SeatScreen(integer(this-object:GetOptionNumericValue("screenHeight")),
                                   integer(this-object:GetOptionNumericValue("screenWidth")),
                                   cast(this-object:GetOptionObjectValue("screenResolution"), ResolutionEnum),
                                   this-object:GetOptionLogicalValue("screenPip"),
                                   this-object:GetOptionLogicalValue("screenTouch"),
                                   oSeat).

        /* Cast? */
        if this-object:HasOption("cast") then
            oSeat = new SeatCast(oSeat).

        /* Controller? */
        if this-object:HasOption("controller") then
            oSeat = new SeatControls(this-object:GetOptionStringValue("controller"), oSeat).

        return oSeat.
    end method.

end class.
