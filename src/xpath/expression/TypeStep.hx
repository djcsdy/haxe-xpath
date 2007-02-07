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


package xpath.expression;
import xpath.expression.PathStep;
import dcxml.Xml;
import xpath.context.Context;
import xpath.token.TypeTestToken;


class TypeStep extends PathStep {
	
	private var type:TypeTestEnum;
	
	
	public function new (type:TypeTestEnum, ?next:PathStep) {
		super(this, next);
		this.type = type;
	}
	
	private function step (context:Context) :Array<Xml> {
		switch (type) {
			case Node:
			if (context.node.type == XmlType.Element || context.node.type == XmlType.Attribute) {
				return [context.node];
			}
			
			case Text:
			if (context.node.type == XmlType.Text) {
				return [context.node];
			}
			
			case Comment:
			// TODO
			return [];
		}
		return [];
	}
	
}