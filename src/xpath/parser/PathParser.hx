/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS AND ANY EXPRESS 
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
import xpath.parser.Parser;
import xpath.XPathInternalException;
import xpath.parser.ParseState;
import xpath.parser.StepParser;
import xpath.token.BeginPathToken;
import xpath.token.StepDelimiterToken;
import xpath.token.EndPathToken;
import xpath.token.TypeTestToken;
import xpath.expression.PathStep;
import xpath.expression.RootStep;
import xpath.expression.TypeStep;


class PathParser implements Parser {
	
	private static var instance:PathParser;
	
	
	public static function getInstance():PathParser {
		if (instance == null) {
			instance = new PathParser();
		}
		return instance;
	}
	
	private function new () {
	}
	
	public function parse (state:ParseState) :ParseState {
		if (!Std.is(state.tokens[state.pos], BeginPathToken)) {
			// fail
			return state.newWorkingCopy();
		}

		var workingState:ParseState = state.newWorkingCopy();
		++workingState.pos;
		
		var absolute:Bool = Std.is(workingState.tokens[workingState.pos], StepDelimiterToken);
		if (absolute) ++workingState.pos;
		
		var firstStep:PathStep;
		workingState = StepParser.getInstance().parse(workingState);
		if (workingState.result == null) {
			// path of "." or "/."
			if (absolute) firstStep = null;
			else firstStep = new TypeStep(Node);
		} else {
			firstStep = cast(workingState.result, PathStep);
		}
		
		if (!Std.is(workingState.tokens[workingState.pos], EndPathToken)) {
			throw new XPathInternalException("Invalid token stream");
		}
		++workingState.pos;
		
		if (absolute) {
			workingState.result = new RootStep(firstStep);
		} else {
			workingState.result = firstStep;
		}

		return workingState;
	}
	
}
