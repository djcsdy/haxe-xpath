/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.parser;
import xpath.XPathInternalException;
import xpath.token.Token;
import xpath.expression.Expression;


class ParseState {
	
	public var tokens(default, null):Array<Token>;
	public var pos(getPos, setPos):Int;
	public var result:Expression;
	
	private var _pos:Int;
	
	
	public function new (tokens:Array<Token>) {
		if (tokens == null) {
			throw new XPathInternalException("Invalid token stream");
		}
		this.tokens = tokens;
		pos = 0;
		result = null;
	}
	
	public function newWorkingCopy () :ParseState {
		var copy:ParseState = new ParseState(tokens);
		copy.pos = pos;
		return copy;
	}
	
	private function getPos () :Int {
		return _pos;
	}
	
	private function setPos (pos:Int) :Int {
		if (pos == null || pos < 0 || pos > tokens.length) _pos = null;
		else _pos = pos;
		return _pos;
	}
	
}